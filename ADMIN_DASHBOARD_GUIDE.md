# Admin Dashboard Guide

## Overview
The Admin Dashboard provides complete administrative control over your JobHub application, allowing you to manage users, jobs, applications, and view analytics.

## Features

### 1. Dashboard Overview
- **Total Statistics**: View counts for users, agents, jobs, and applications
- **Active/Inactive Jobs**: Monitor job posting status
- **Weekly Growth**: Track new users, jobs, and applications from the past 7 days
- **Quick Actions**: Direct navigation to management pages

### 2. User Management
- **View All Users**: Browse paginated list of all users (20 per page)
- **Search Users**: Search by username or email
- **Make/Remove Agents**: Toggle agent status for users
- **Delete Users**: Remove users and all their associated data (applications, bookmarks)
- **User Details**: View profile picture, email, location, and phone

### 3. Job Management
- **View All Jobs**: Browse all job postings
- **Filter Jobs**: Filter by status (All, Active, Inactive)
- **Search Jobs**: Search by title, company, or location
- **Activate/Deactivate Jobs**: Toggle hiring status
- **Delete Jobs**: Remove jobs and associated data

### 4. Analytics
- **User Growth Chart**: 6-month trend of new user registrations
- **Job Posting Chart**: 6-month trend of job postings
- **Application Chart**: 6-month trend of job applications
- **Interactive Line Charts**: Visual representation with fl_chart

## Backend Implementation

### API Endpoints

All admin endpoints are protected by authentication and admin verification middleware.

**Base URL**: `/api/admin`

#### Dashboard Stats
```
GET /api/admin/stats
```
Returns overview statistics including total users, jobs, applications, and weekly growth.

#### User Management
```
GET /api/admin/users?page=1&limit=20&search=keyword
GET /api/admin/users/:id
PUT /api/admin/users/:id/status
DELETE /api/admin/users/:id
```

#### Job Management
```
GET /api/admin/jobs?page=1&limit=20&search=keyword&status=all
PUT /api/admin/jobs/:id/status
DELETE /api/admin/jobs/:id
```

#### Applications
```
GET /api/admin/applications?page=1&limit=20
```

#### Agents
```
GET /api/admin/agents?page=1&limit=20
```

#### Analytics
```
GET /api/admin/analytics/user-growth
GET /api/admin/analytics/job-posting
GET /api/admin/analytics/applications
```

### Security
- **verifyToken**: Ensures user is authenticated
- **verifyAdmin**: Checks if user has `isAdmin: true` in the database
- Both middlewares must pass before accessing admin routes

## Frontend Implementation

### Flutter Files Created

1. **Models** (`lib/models/admin_models.dart`):
   - `AdminStats`: Dashboard statistics
   - `AdminUser`: User data for admin view
   - `AdminJob`: Job data for admin view
   - `ChartData`: Analytics chart data

2. **Service** (`lib/services/admin_service.dart`):
   - `AdminService`: HTTP requests to backend admin endpoints
   - Token-based authentication
   - Error handling

3. **Auth Helper** (`lib/services/auth_helper.dart`):
   - `AuthHelper`: Check admin status
   - Cache admin status locally
   - Get user data

4. **UI Pages**:
   - `admin_dashboard_page.dart`: Main dashboard with stats and quick actions
   - `admin_users_page.dart`: User management interface
   - `admin_jobs_page.dart`: Job management interface
   - `admin_analytics_page.dart`: Charts and analytics

### Navigation
The admin dashboard is integrated into the main app drawer and only appears when the user has admin privileges.

## Setup Instructions

### 1. Backend Setup

1. **Restart Backend Server**:
   ```bash
   cd backend
   node index.js
   ```

2. **Make a User Admin**:
   You need to manually set a user as admin in MongoDB:
   
   ```javascript
   // Using MongoDB Compass or shell
   db.users.updateOne(
     { email: "admin@example.com" },
     { $set: { isAdmin: true } }
   )
   ```

   Or using MongoDB shell:
   ```bash
   mongo
   use your_database_name
   db.users.updateOne(
     { email: "admin@example.com" },
     { $set: { isAdmin: true } }
   )
   ```

### 2. Flutter Setup

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Update Base URL** (for production):
   In `lib/services/admin_service.dart`, update:
   ```dart
   static const String baseUrl = 'YOUR_PRODUCTION_URL/api/admin';
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

### 3. Testing the Admin Dashboard

1. **Login as Admin**:
   - Use credentials of the user you marked as admin
   
2. **Access Dashboard**:
   - Open the drawer menu
   - You should see "Admin Dashboard" option (shield icon)
   - Tap to access the dashboard

3. **Verify Functionality**:
   - Check dashboard stats are loading
   - Try managing users (make agent, delete)
   - Try managing jobs (activate/deactivate, delete)
   - View analytics charts

## API Configuration

### Development (Android Emulator)
```dart
static const String baseUrl = 'http://10.0.2.2:5002/api/admin';
```

### Development (iOS Simulator)
```dart
static const String baseUrl = 'http://localhost:5002/api/admin';
```

### Production
```dart
static const String baseUrl = 'https://your-domain.com/api/admin';
```

## Dependencies Added

Added to `pubspec.yaml`:
```yaml
fl_chart: ^0.65.0  # For analytics charts
```

## Security Best Practices

1. **Never expose admin credentials** in the app
2. **Always verify admin status** on the backend
3. **Use HTTPS** in production
4. **Implement rate limiting** for admin endpoints
5. **Log admin actions** for audit trails
6. **Use strong passwords** for admin accounts

## Troubleshooting

### Admin Menu Not Showing
- Ensure user has `isAdmin: true` in database
- Check authentication token is valid
- Verify network connection to backend

### API Errors
- Check backend server is running
- Verify MongoDB connection
- Check console for error messages
- Ensure correct base URL

### Charts Not Loading
- Ensure fl_chart dependency is installed
- Check analytics endpoints return valid data
- Verify date formatting in backend

## Future Enhancements

Consider adding:
- Email notifications for admin actions
- Role-based permissions (super admin, moderator)
- Activity logs and audit trails
- Bulk operations (delete multiple users/jobs)
- Export data to CSV
- Advanced filtering and sorting
- Dashboard customization
- Real-time updates with WebSockets

## Support

For issues or questions:
1. Check backend logs: `backend/` folder
2. Check Flutter console for errors
3. Verify database connection
4. Test API endpoints with Postman

---

**Created**: Admin Dashboard for JobHub
**Version**: 1.0.0
**Last Updated**: January 2026
