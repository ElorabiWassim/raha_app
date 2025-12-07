$baseUrl = "http://localhost:3000/api/auth"

Write-Host "1. Testing Signup Homeowner..." -ForegroundColor Cyan
$hoEmail = "ho_$(Get-Date -Format 'yyyyMMddHHmmss')@test.com"
$hoBody = @{
    email = $hoEmail
    password = "password123"
    fullName = "Test Homeowner"
    phoneNumber = "1234567890"
    homeAddress = "123 Main St"
    dateOfBirth = "1990-01-01"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/signup/homeowner" -Method Post -Body $hoBody -ContentType "application/json"
    Write-Host "Success: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        Write-Host "Details: $($reader.ReadToEnd())" -ForegroundColor Red
    }
}

Write-Host "`n2. Testing Signup Provider..." -ForegroundColor Cyan
$spEmail = "sp_$(Get-Date -Format 'yyyyMMddHHmmss')@test.com"
# Note: serviceType needs to be a valid UUID. Using a nil UUID might fail FK constraints.
$spBody = @{
    email = $spEmail
    password = "password123"
    fullName = "Test Provider"
    phoneNumber = "0987654321"
    workingAddress = "456 Work St"
    dateOfBirth = "1985-05-05"
    serviceType = "00000000-0000-0000-0000-000000000000"
    experienceYears = 5
    description = "Expert plumber"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/signup/provider" -Method Post -Body $spBody -ContentType "application/json"
    Write-Host "Success: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
     if ($_.Exception.Response) {
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        Write-Host "Details: $($reader.ReadToEnd())" -ForegroundColor Red
    }
}

Write-Host "`n3. Testing Login..." -ForegroundColor Cyan
$loginBody = @{
    email = $hoEmail
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/login" -Method Post -Body $loginBody -ContentType "application/json"
    Write-Host "Login Success!" -ForegroundColor Green
    $token = $loginResponse.session.access_token
    Write-Host "Token: $token"

    Write-Host "`n4. Testing Protected Route (Logout)..." -ForegroundColor Cyan
    $headers = @{
        Authorization = "Bearer $token"
    }
    $logoutResponse = Invoke-RestMethod -Uri "$baseUrl/logout" -Method Post -Headers $headers
    Write-Host "Logout Success: $($logoutResponse.message)" -ForegroundColor Green

} catch {
    Write-Host "Login/Logout Error: $($_.Exception.Message)" -ForegroundColor Red
     if ($_.Exception.Response) {
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        Write-Host "Details: $($reader.ReadToEnd())" -ForegroundColor Red
    }
}
