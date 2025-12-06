$baseUrl = "http://localhost:3000/api"
$random = Get-Random
$emailHO = "homeowner_$random@test.com"
$emailSP = "provider_$random@test.com"
$password = "TestPass123!"

function Test-Endpoint {
    param ($Name, $Method, $Url, $Body, $AuthToken)
    Write-Host "Testing $Name..." -NoNewline
    
    $headers = @{}
    if ($AuthToken) { $headers["Authorization"] = "Bearer $AuthToken" }
    
    try {
        $params = @{
            Uri = $Url
            Method = $Method
            ContentType = "application/json"
            Headers = $headers
        }
        if ($Body) { $params.Body = ($Body | ConvertTo-Json -Depth 5) }
        
        $response = Invoke-RestMethod @params
        Write-Host " [OK]" -ForegroundColor Green
        return $response
    } catch {
        Write-Host " [FAILED]" -ForegroundColor Red
        Write-Host $_.Exception.Message
        if ($_.Exception.Response) {
            $reader = New-Object System.IO.StreamReader $_.Exception.Response.GetResponseStream()
            Write-Host $reader.ReadToEnd()
        }
        return $null
    }
}

# 1. Signup Homeowner
$hoBody = @{
    email = $emailHO
    password = $password
    fullName = "Test Homeowner"
    phoneNumber = "+213555123456"
    homeAddress = "123 Test St"
    dateOfBirth = "1990-01-01"
}
$hoRes = Test-Endpoint -Name "Signup Homeowner" -Method "Post" -Url "$baseUrl/auth/signup/homeowner" -Body $hoBody

if ($hoRes) {
    $tokenHO = $hoRes.session.access_token
    Write-Host "Homeowner Token received."
}

# 2. Signup Provider
$spBody = @{
    email = $emailSP
    password = $password
    fullName = "Test Provider"
    phoneNumber = "+213555987654"
    workingAddress = "456 Work St"
    dateOfBirth = "1985-01-01"
    serviceType = "00000000-0000-0000-0000-000000000000"
    experienceYears = 5
    description = "Test Description"
    documentsUrls = @{ id = "url" }
}
$spRes = Test-Endpoint -Name "Signup Provider" -Method "Post" -Url "$baseUrl/auth/signup/provider" -Body $spBody

if ($spRes) {
    $tokenSP = $spRes.session.access_token
    Write-Host "Provider Token received."
}

# 3. Get Profile (Homeowner)
if ($tokenHO) {
    $profileHO = Test-Endpoint -Name "Get Profile (Homeowner)" -Method "Get" -Url "$baseUrl/profile" -AuthToken $tokenHO
    if ($profileHO.profile.role -eq 'homeowner') { Write-Host "Role Verified: Homeowner" -ForegroundColor Cyan }
}

# 4. Get Profile (Provider)
if ($tokenSP) {
    $profileSP = Test-Endpoint -Name "Get Profile (Provider)" -Method "Get" -Url "$baseUrl/profile" -AuthToken $tokenSP
    if ($profileSP.profile.role -eq 'service_provider') { Write-Host "Role Verified: Service Provider" -ForegroundColor Cyan }
    if ($profileSP.profile.verification_status -eq 'pending') { Write-Host "Status Verified: Pending" -ForegroundColor Cyan }
}

# 5. Update Profile (Homeowner)
if ($tokenHO) {
    $updateBody = @{ full_name = "Updated Homeowner Name" }
    Test-Endpoint -Name "Update Profile" -Method "Put" -Url "$baseUrl/profile" -Body $updateBody -AuthToken $tokenHO
}

# 6. Login
$loginBody = @{ email = $emailHO; password = $password }
$loginRes = Test-Endpoint -Name "Login" -Method "Post" -Url "$baseUrl/auth/login" -Body $loginBody

# 7. Delete Account
if ($tokenHO) {
    Test-Endpoint -Name "Delete Account (HO)" -Method "Delete" -Url "$baseUrl/profile/account" -AuthToken $tokenHO
}
if ($tokenSP) {
    Test-Endpoint -Name "Delete Account (SP)" -Method "Delete" -Url "$baseUrl/profile/account" -AuthToken $tokenSP
}

