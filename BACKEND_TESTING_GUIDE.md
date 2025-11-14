# Backend API Testing Guide

## 🧪 cURL Commands for Postman Testing

### Base URLs:
- **For Postman/Desktop**: `http://localhost:5002`
- **For Android Emulator**: `http://10.0.2.2:5002`

## 1. Test Server Health (No Auth Required)

```bash
curl -X GET http://localhost:5002/api/users/test
```

**Expected Response:**
```json
{
  "message": "Test endpoint hit",
  "type": "single_object"
}
```

## 2. User Registration

```bash
curl -X POST http://localhost:5002/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "testpass123"
  }'
```

## 3. User Login

```bash
curl -X POST http://localhost:5002/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testpass123"
  }'
```

**This will return a JWT token like:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {...}
}
```

## 4. Get User Profile (Requires Auth Token)

```bash
curl -X GET http://localhost:5002/api/users/profile \
  -H "Content-Type: application/json" \
  -H "authorization: Bearer YOUR_JWT_TOKEN_HERE"
```

## 5. Get Jobs (No Auth Required)

```bash
curl -X GET http://localhost:5002/api/jobs
```

## 6. Search Jobs

```bash
curl -X GET "http://localhost:5002/api/jobs/search/developer"
```

---

## 🔧 Troubleshooting Steps

### Step 1: Start Backend Server
```bash
cd backend
npm start
```
**Should show:** `Product server listening on 0.0.0.0:5002`

### Step 2: Test Basic Connectivity
Use the test endpoint first to ensure server is running.

### Step 3: Check Database Connection
The server should also show: `connected to the db`

### Step 4: Test Authentication Flow
1. Register a user
2. Login to get token
3. Use token for profile endpoint

---

## 🔍 Frontend Issue Diagnosis

### Current Error Analysis:
- **Error**: "Failed to get the profile. Status code: 403"
- **Location**: `lib/services/helpers/auth_helper.dart` line 129
- **Cause**: Missing or invalid authentication token

### Check Frontend Auth Token:
The app should have a valid JWT token stored in SharedPreferences before calling profile endpoint.

### Debug Steps:
1. Check if user is logged in
2. Verify token exists in SharedPreferences  
3. Ensure token is being sent in Authorization header
4. Check token expiration