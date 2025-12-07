#!/bin/bash

BASE_URL="http://localhost:3000/api/auth"

echo "1. Testing Signup Homeowner..."
curl -X POST "$BASE_URL/signup/homeowner" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ho_'$(date +%s)'@test.com",
    "password": "password123",
    "fullName": "Test Homeowner",
    "phoneNumber": "1234567890",
    "homeAddress": "123 Main St",
    "dateOfBirth": "1990-01-01"
  }'
echo -e "\n"

echo "2. Testing Signup Provider..."
# Note: serviceType should be a valid UUID from service_categories table. 
# Using a random UUID here might fail if FK constraints exist.
curl -X POST "$BASE_URL/signup/provider" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "sp_'$(date +%s)'@test.com",
    "password": "password123",
    "fullName": "Test Provider",
    "phoneNumber": "0987654321",
    "workingAddress": "456 Work St",
    "dateOfBirth": "1985-05-05",
    "serviceType": "00000000-0000-0000-0000-000000000000", 
    "experienceYears": 5,
    "description": "Expert plumber"
  }'
echo -e "\n"

echo "3. Testing Login..."
# We need to use one of the emails we just created. 
# For simplicity in this script, let's try to login with a fixed email 
# (assuming you run this script once or clean up DB).
# Or better, let's just login with the homeowner we just tried to create.
# Since we used a dynamic email, we cant easily grab it in simple bash without parsing.
# So I will use a fixed email for a "Login Test User" that we create first.

FIXED_EMAIL="fixed_user_$(date +%s)@test.com"

echo "Creating a fixed user for login test: $FIXED_EMAIL"
curl -s -X POST "$BASE_URL/signup/homeowner" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'"$FIXED_EMAIL"'",
    "password": "password123",
    "fullName": "Login Tester",
    "phoneNumber": "5555555555",
    "homeAddress": "Login St",
    "dateOfBirth": "2000-01-01"
  }' > /dev/null

echo "Logging in with $FIXED_EMAIL..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'"$FIXED_EMAIL"'",
    "password": "password123"
  }')

echo "Login Response: $LOGIN_RESPONSE"

# Extract Token (simple grep/sed, assuming json response)
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -n "$TOKEN" ]; then
  echo "Token received: $TOKEN"
  
  echo "4. Testing Protected Route (Logout)..."
  curl -X POST "$BASE_URL/logout" \
    -H "Authorization: Bearer $TOKEN"
  echo -e "\n"
else
  echo "Failed to get token, skipping logout test."
fi
