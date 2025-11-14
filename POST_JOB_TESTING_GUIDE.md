# POST Job Testing Guide

## 🎯 **Requirements to POST a Job:**

1. **User must be logged in** (have a valid JWT token)
2. **User must be an Agent** (`isAgent: true`) or Admin (`isAdmin: true`)
3. **All required job fields** must be provided

## 📝 **Required Job Fields:**

```json
{
  "title": "Software Engineer",
  "location": "New York, USA", 
  "company": "Tech Corp",
  "description": "We are looking for a skilled software engineer...",
  "agentName": "John Doe",
  "salary": "$80,000 - $120,000",
  "period": "Full-time",
  "hiring": true,
  "contract": "Permanent",
  "requirements": ["Bachelor's degree", "3+ years experience", "JavaScript", "React"],
  "imageUrl": "https://example.com/company-logo.png",
  "agentId": "your-agent-user-id"
}
```

## 🧪 **Testing Steps:**

### Step 1: Register a User (if needed)

```bash
Invoke-WebRequest -Uri "http://localhost:5002/api/register" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{
  "username": "testagent",
  "email": "agent@test.com", 
  "password": "testpass123"
}'
```

### Step 2: Login to Get Token

```bash
Invoke-WebRequest -Uri "http://localhost:5002/api/login" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{
  "email": "agent@test.com",
  "password": "testpass123"
}'
```

**Save the token from the response!**

### Step 3: Make User an Agent (Update User Profile)

You need to update the user to have `isAgent: true`. Check if there's an endpoint for this.

### Step 4: POST Job with Token

```bash
Invoke-WebRequest -Uri "http://localhost:5002/api/jobs" -Method POST -Headers @{
  "Content-Type"="application/json"
  "Authorization"="Bearer YOUR_JWT_TOKEN_HERE"
} -Body '{
  "title": "Test Software Engineer",
  "location": "Remote",
  "company": "Test Company",
  "description": "This is a test job posting for development purposes.",
  "agentName": "Test Agent",
  "salary": "$60,000 - $80,000",
  "period": "Full-time", 
  "hiring": true,
  "contract": "Permanent",
  "requirements": ["Programming", "Problem solving"],
  "imageUrl": "https://via.placeholder.com/200",
  "agentId": "YOUR_USER_ID_HERE"
}'
```

## ❌ **Why You're Getting 403:**

The 403 error means either:
1. **No authentication token** provided
2. **Invalid/expired token**
3. **User is not an agent** (`isAgent: false`)
4. **Token format incorrect** (should be `Bearer <token>`)

## 🔧 **Quick Test Without Authentication:**

Try this endpoint that doesn't require auth:

```bash
# Test server is working
Invoke-WebRequest -Uri "http://localhost:5002/api/users/test" -Method GET

# Get existing jobs (no auth required)  
Invoke-WebRequest -Uri "http://localhost:5002/api/jobs" -Method GET
```

## 🚀 **Next Steps:**

1. **Test user registration/login flow**
2. **Get a valid JWT token**  
3. **Make sure user has agent permissions**
4. **Try POST job with proper authentication**

Would you like me to help you test the login flow first?