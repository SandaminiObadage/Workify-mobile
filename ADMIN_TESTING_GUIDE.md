# 🧪 Admin Dashboard Testing Guide

## Pre-Testing Setup

### 1. Start Backend Server
```bash
cd backend
node index.js
```

Expected output:
```
connected to the db
Product server listening on 0.0.0.0:5002
```

### 2. Create Test Data

#### Create Test Users
Register 3-5 users through the app to have test data.

#### Make One User Admin
```bash
cd backend
node makeAdmin.js add admin@test.com
```

Expected output:
```
Connected to database
✓ Success! User 'admin' (admin@test.com) is now an admin.
```

### 3. Start Flutter App
```bash
flutter pub get
flutter run
```

---

## 🔍 Test Cases

### Test 1: Admin Menu Visibility

**Purpose**: Verify admin menu only shows for admin users

#### Steps:
1. Login with **non-admin** user
2. Open drawer menu
3. **Expected**: No "Admin Dashboard" option visible

4. Logout
5. Login with **admin** user
6. Open drawer menu
7. **Expected**: "Admin Dashboard" option visible with shield icon

**✅ Pass Criteria**: Admin menu only visible for admin users

---

### Test 2: Dashboard Statistics

**Purpose**: Verify dashboard loads correct statistics

#### Steps:
1. Login as admin
2. Navigate to Admin Dashboard
3. Observe loading indicator
4. **Expected**: Dashboard displays:
   - Total Users count
   - Total Jobs count
   - Total Applications count
   - Total Agents count
   - Active Jobs count
   - Inactive Jobs count
   - New Users This Week
   - New Jobs This Week
   - New Applications This Week

5. Pull down to refresh
6. **Expected**: Stats reload

**✅ Pass Criteria**: 
- All stats display correctly
- Numbers match database counts
- Refresh works

---

### Test 3: User Management - View Users

**Purpose**: Test viewing and searching users

#### Steps:
1. Navigate to "Manage Users" from dashboard
2. **Expected**: List of users displays (20 per page)
3. Each user card shows:
   - Profile picture
   - Username
   - Email
   - Location (if set)
   - Phone (if set)
   - "AGENT" badge if applicable

4. Type in search box: part of a username
5. **Expected**: Results filter in real-time
6. Clear search
7. **Expected**: All users return

**✅ Pass Criteria**: 
- Users display correctly
- Search filters results
- Pagination works (if >20 users)

---

### Test 4: User Management - Toggle Agent Status

**Purpose**: Test making users agents

#### Steps:
1. On Manage Users page, find a non-agent user
2. Tap "Make Agent" button
3. **Expected**: 
   - Confirmation message appears
   - User list refreshes
   - User now has "AGENT" badge
   - Button changes to "Remove Agent"

4. Tap "Remove Agent"
5. **Expected**:
   - Confirmation message appears
   - "AGENT" badge removed
   - Button changes to "Make Agent"

**✅ Pass Criteria**: Agent status toggles correctly

---

### Test 5: User Management - Delete User

**Purpose**: Test user deletion

#### Steps:
1. On Manage Users page, find a test user
2. Tap delete icon (trash can)
3. **Expected**: Confirmation dialog appears
4. Tap "Cancel"
5. **Expected**: User not deleted, dialog closes

6. Tap delete icon again
7. Tap "Delete"
8. **Expected**:
   - Success message appears
   - User removed from list
   - User deleted from database

**⚠️ Warning**: This actually deletes data!

**✅ Pass Criteria**: 
- Confirmation required
- Cancel works
- Delete removes user

---

### Test 6: Job Management - View Jobs

**Purpose**: Test viewing and filtering jobs

#### Steps:
1. Navigate to "Manage Jobs" from dashboard
2. **Expected**: List of jobs displays
3. Each job card shows:
   - Title
   - Company
   - Location
   - Salary
   - Status badge (ACTIVE/INACTIVE)

4. Tap "Active" filter chip
5. **Expected**: Only active jobs show
6. Tap "Inactive" filter chip
7. **Expected**: Only inactive jobs show
8. Tap "All" filter chip
9. **Expected**: All jobs show

**✅ Pass Criteria**: Filters work correctly

---

### Test 7: Job Management - Search Jobs

**Purpose**: Test job search functionality

#### Steps:
1. On Manage Jobs page
2. Type job title in search box
3. **Expected**: Results filter by title
4. Clear and type company name
5. **Expected**: Results filter by company
6. Clear and type location
7. **Expected**: Results filter by location

**✅ Pass Criteria**: Search works for all fields

---

### Test 8: Job Management - Toggle Job Status

**Purpose**: Test activating/deactivating jobs

#### Steps:
1. Find an active job
2. Tap "Deactivate" button
3. **Expected**:
   - Confirmation message
   - Status badge changes to "INACTIVE"
   - Button changes to "Activate"

4. Tap "Activate"
5. **Expected**:
   - Status badge changes to "ACTIVE"
   - Button changes to "Deactivate"

**✅ Pass Criteria**: Job status toggles correctly

---

### Test 9: Job Management - Delete Job

**Purpose**: Test job deletion

#### Steps:
1. Find a test job
2. Tap delete icon
3. **Expected**: Confirmation dialog
4. Tap "Cancel"
5. **Expected**: Job not deleted

6. Tap delete icon again
7. Tap "Delete"
8. **Expected**:
   - Success message
   - Job removed from list

**⚠️ Warning**: This actually deletes data!

**✅ Pass Criteria**: Deletion works with confirmation

---

### Test 10: Analytics - View Charts

**Purpose**: Test analytics visualization

#### Steps:
1. Navigate to "View Analytics" from dashboard
2. **Expected**: Three charts load:
   - User Growth (Last 6 Months)
   - Job Postings (Last 6 Months)
   - Applications (Last 6 Months)

3. Each chart should show:
   - Month labels on X-axis
   - Count values on Y-axis
   - Curved line connecting data points
   - Shaded area under line

4. Pull down to refresh
5. **Expected**: Charts reload

**✅ Pass Criteria**: 
- All charts display
- Data is visualized correctly
- Refresh works

---

### Test 11: Error Handling - No Connection

**Purpose**: Test app behavior when backend is down

#### Steps:
1. Stop backend server
2. In app, navigate to Admin Dashboard
3. **Expected**: Error message displays
4. **Expected**: "Retry" button visible

5. Restart backend server
6. Tap "Retry"
7. **Expected**: Data loads successfully

**✅ Pass Criteria**: Graceful error handling

---

### Test 12: Error Handling - Unauthorized Access

**Purpose**: Test non-admin access attempt

#### Steps:
1. Get authentication token from non-admin user
2. Try to access admin endpoint directly (e.g., via Postman)
3. **Expected**: 403 Forbidden error

**Example Postman Test**:
```
GET http://localhost:5002/api/admin/stats
Headers:
  token: Bearer {non-admin-token}

Expected Response:
{
  "message": "Forbidden - Admin access required"
}
```

**✅ Pass Criteria**: Non-admins cannot access endpoints

---

### Test 13: Pagination

**Purpose**: Test pagination works correctly

#### Steps:
1. Ensure you have >20 users or jobs
2. Navigate to Manage Users/Jobs
3. **Expected**: "Page 1 of X" displays
4. Tap right arrow
5. **Expected**: 
   - Page number increments
   - Next batch of items loads
6. Tap left arrow
7. **Expected**:
   - Page number decrements
   - Previous batch loads

**✅ Pass Criteria**: Navigation between pages works

---

### Test 14: Pull to Refresh

**Purpose**: Test refresh functionality

#### Steps:
1. On any admin page with a list
2. Pull down from top
3. **Expected**: 
   - Loading indicator appears
   - Data refreshes
   - Indicator disappears

**✅ Pass Criteria**: Refresh works on all pages

---

### Test 15: Back Navigation

**Purpose**: Test navigation flow

#### Steps:
1. Dashboard → Manage Users → Back button
2. **Expected**: Returns to Dashboard

3. Dashboard → Manage Jobs → Back button
4. **Expected**: Returns to Dashboard

5. Dashboard → View Analytics → Back button
6. **Expected**: Returns to Dashboard

**✅ Pass Criteria**: Navigation hierarchy correct

---

## 📊 Test Results Template

```
Date: _______________
Tester: _______________

[ ] Test 1: Admin Menu Visibility
[ ] Test 2: Dashboard Statistics
[ ] Test 3: User Management - View Users
[ ] Test 4: User Management - Toggle Agent Status
[ ] Test 5: User Management - Delete User
[ ] Test 6: Job Management - View Jobs
[ ] Test 7: Job Management - Search Jobs
[ ] Test 8: Job Management - Toggle Job Status
[ ] Test 9: Job Management - Delete Job
[ ] Test 10: Analytics - View Charts
[ ] Test 11: Error Handling - No Connection
[ ] Test 12: Error Handling - Unauthorized Access
[ ] Test 13: Pagination
[ ] Test 14: Pull to Refresh
[ ] Test 15: Back Navigation

Issues Found:
_________________________________
_________________________________
_________________________________

Notes:
_________________________________
_________________________________
_________________________________
```

---

## 🐛 Common Issues & Solutions

### Issue: Admin menu not showing
**Solution**: 
- Verify user has `isAdmin: true` in database
- Logout and login again
- Check `AuthHelper.isAdmin()` is being called

### Issue: 403 Forbidden errors
**Solution**:
- Check backend server is running
- Verify token is valid
- Confirm user is admin

### Issue: Charts not loading
**Solution**:
- Run `flutter pub get`
- Check if fl_chart is installed
- Verify analytics endpoints return data

### Issue: "No data available"
**Solution**:
- Create test data in database
- Ensure MongoDB has records
- Check date ranges in queries

---

## 🎯 Acceptance Criteria

✅ All 15 test cases pass
✅ No console errors
✅ Smooth UI performance
✅ Proper error messages
✅ Confirmation dialogs work
✅ Pagination smooth
✅ Search responsive
✅ Charts visualize correctly
✅ Security enforced

---

## 📝 Testing Notes

- Test on both Android and iOS if possible
- Test with different screen sizes
- Test with slow network (throttling)
- Test with large datasets (100+ users/jobs)
- Verify database changes after operations
- Check for memory leaks on repeated operations

---

**Ready to Test?** Start from Test 1 and work through sequentially!
