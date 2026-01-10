#!/bin/bash
BASE_URL="http://10.242.249.27:3000/api"

# 1. Signup Homeowner
curl -X POST "$BASE_URL/auth/signup/homeowner" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test_ho@example.com",
    "password": "Password123!",
    "fullName": "Test Homeowner",
    "phoneNumber": "1234567890",
    "homeAddress": "Algiers",
    "dateOfBirth": "1990-01-01"
  }'

# 2. Signup Provider
curl -X POST "$BASE_URL/auth/signup/provider" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test_sp@example.com",
    "password": "Password123!",
    "fullName": "Test Provider",
    "phoneNumber": "0987654321",
    "workingAddress": "Oran",
    "dateOfBirth": "1985-05-05",
    "serviceType": "plumber",
    "experienceYears": 5,
    "description": "Expert plumber",
    "documentsUrls": {}
  }'

# 3. Login
curl -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test_ho@example.com",
    "password": "Password123!"
  }'

# NOTE: Copy the access_token from the login response for the next steps

# 4. Get Profile
# Replace TOKEN with your actual token
# curl -H "Authorization: Bearer TOKEN" "$BASE_URL/profile"
