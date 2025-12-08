# Quick Test Script for SP Reviews
# Run this in PowerShell from the backend directory

Write-Host "🧪 Testing SP Review Endpoints" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

# Test SP ID (replace with actual ID from your database)
$spId = "5e7910fe-9b5e-4d0a-adeb-327e8781c0e7"

Write-Host "📍 Using SP ID: $spId`n" -ForegroundColor Yellow

# Test 1: Get Reviews
Write-Host "Test 1: GET /api/sp/reviews/$spId" -ForegroundColor Green
try {
    $reviews = Invoke-RestMethod -Uri "http://localhost:5000/api/sp/reviews/$spId" -Method Get -ErrorAction Stop
    Write-Host "Success!" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor White
    $reviews | ConvertTo-Json -Depth 10
    Write-Host "`nTotal reviews: $($reviews.count)" -ForegroundColor Cyan
}
catch {
    Write-Host "Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n---`n"

# Test 2: Get Average Rating
Write-Host "Test 2: GET /api/sp/rating/$spId" -ForegroundColor Green
try {
    $rating = Invoke-RestMethod -Uri "http://localhost:5000/api/sp/rating/$spId" -Method Get -ErrorAction Stop
    Write-Host "Success!" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor White
    $rating | ConvertTo-Json -Depth 10
    
    if ($rating.data) {
        Write-Host "`nAverage Rating: $($rating.data.average_rating)" -ForegroundColor Yellow
        Write-Host "Total Reviews: $($rating.data.total_reviews)" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n================================" -ForegroundColor Cyan
Write-Host "Test Complete!" -ForegroundColor Cyan
