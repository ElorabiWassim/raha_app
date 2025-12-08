# Test all endpoints - Update TOKEN with a valid JWT from Supabase
$TOKEN = "your-jwt-token-here"
$BASE_URL = "http://localhost:5000"

Write-Host "`n=== Testing Public Endpoints ===" -ForegroundColor Green

# Test SP rating
Write-Host "`n1. GET /api/sp/rating/:spId" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/api/sp/rating/123e4567-e89b-12d3-a456-426614174000" -Method GET
    Write-Host "✓ Success: $($response | ConvertTo-Json -Depth 2)" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

# Test SP reviews
Write-Host "`n2. GET /api/sp/reviews/:spId" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/api/sp/reviews/123e4567-e89b-12d3-a456-426614174000" -Method GET
    Write-Host "✓ Success: $($response | ConvertTo-Json -Depth 2)" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

Write-Host "`n=== Testing Protected Endpoints (requires valid token) ===" -ForegroundColor Green

if ($TOKEN -eq "your-jwt-token-here") {
    Write-Host "`n⚠ Skipping protected endpoint tests - Please update TOKEN variable with a valid JWT" -ForegroundColor Yellow
    exit
}

$headers = @{
    "Authorization" = "Bearer $TOKEN"
    "Content-Type"  = "application/json"
}

# Test conversations
Write-Host "`n3. GET /api/conversations" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/api/conversations" -Method GET -Headers $headers
    Write-Host "✓ Success: Found $($response.data.Count) conversations" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

# Test admin stats
Write-Host "`n4. GET /api/admin/stats (requires admin role)" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/api/admin/stats" -Method GET -Headers $headers
    Write-Host "✓ Success: $($response | ConvertTo-Json -Depth 2)" -ForegroundColor Green
}
catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
}

Write-Host "`n=== Test Complete ===" -ForegroundColor Green
