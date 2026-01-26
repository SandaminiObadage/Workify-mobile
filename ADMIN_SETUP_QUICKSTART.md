# 🛡️ Quick Start: Admin Dashboard Setup

## Step 1: Start Backend Server

```bash
cd backend
node index.js
```

The server should start on `http://localhost:5002` (or your configured port).

## Step 2: Create Admin User

You have two options:

### Option A: Using the Admin Script (Recommended)

1. Make sure you have a registered user in the app
2. Run the admin script:

```bash
cd backend
node makeAdmin.js add user@example.com
```

**List all admins:**
```bash
node makeAdmin.js list
```

**Remove admin status:**
```bash
node makeAdmin.js remove user@example.com
```

### Option B: Using MongoDB Directly

**Using MongoDB Compass:**
1. Open MongoDB Compass
2. Connect to your database
3. Navigate to the `users` collection
4. Find the user you want to make admin
5. Edit the document and set `isAdmin: true`

**Using MongoDB Shell:**
```bash
mongo
use your_database_name
db.users.updateOne(
  { email: "user@example.com" },
  { $set: { isAdmin: true } }
)
```

## Step 3: Install Flutter Dependencies

```bash
flutter pub get
```

This will install the `fl_chart` package needed for analytics.

## Step 4: Run the App

```bash
flutter run
```

## Step 5: Access Admin Dashboard

1. **Login** with the admin user credentials
2. **Open drawer** menu (swipe from left or tap menu icon)
3. **Look for "Admin Dashboard"** with shield icon
4. **Tap to access** the admin panel

## 🎯 What You Can Do

### Dashboard Overview
- View total users, jobs, applications, agents
- See weekly growth statistics
- Quick access to management pages

### User Management
- Search and filter users
- Make users agents or remove agent status
- Delete users and their data
- View user profiles and activity

### Job Management  
- Filter jobs by status (Active/Inactive)
- Search jobs by title, company, location
- Activate or deactivate job postings
- Delete jobs

### Analytics
- User growth over 6 months
- Job posting trends
- Application statistics
- Interactive charts

## 🔧 Configuration

### Update API URL for Production

In `lib/services/admin_service.dart`:

```dart
// Change this line
static const String baseUrl = 'http://10.0.2.2:5002/api/admin';

// To your production URL
static const String baseUrl = 'https://yourdomain.com/api/admin';
```

In `lib/services/auth_helper.dart`:

```dart
// Change this line
static const String baseUrl = 'http://10.0.2.2:5002/api/users';

// To your production URL
static const String baseUrl = 'https://yourdomain.com/api/users';
```

## 🐛 Troubleshooting

### Admin Menu Not Showing?
- ✓ Check user has `isAdmin: true` in database
- ✓ Logout and login again
- ✓ Verify backend server is running

### Can't Connect to API?
- ✓ Backend server running on correct port?
- ✓ Using correct IP address (10.0.2.2 for Android emulator)
- ✓ Check firewall settings

### Charts Not Loading?
- ✓ Run `flutter pub get` to install fl_chart
- ✓ Check analytics endpoints return data
- ✓ Verify MongoDB has data to display

## 📱 Testing Checklist

- [ ] Backend server running
- [ ] User marked as admin in database
- [ ] Flutter dependencies installed
- [ ] Can login with admin user
- [ ] Admin Dashboard appears in drawer
- [ ] Dashboard stats load correctly
- [ ] Can view and search users
- [ ] Can view and search jobs
- [ ] Analytics charts display properly
- [ ] Can toggle user agent status
- [ ] Can activate/deactivate jobs

## 🚀 Next Steps

1. **Create your first admin user** using the script
2. **Test all features** in development
3. **Update API URLs** for production
4. **Deploy backend** to your server
5. **Build and deploy** Flutter app

## 📚 Full Documentation

See [ADMIN_DASHBOARD_GUIDE.md](ADMIN_DASHBOARD_GUIDE.md) for complete documentation including:
- Detailed feature descriptions
- API endpoint documentation
- Security best practices
- Advanced configuration
- Future enhancement ideas

---

**Need Help?** Check the troubleshooting section above or review the backend logs for errors.
