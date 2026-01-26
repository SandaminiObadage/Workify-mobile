# Admin Dashboard Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          FLUTTER APP                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌──────────────┐    ┌──────────────────────────────────────────┐  │
│  │   Drawer     │───▶│  Is User Admin?                          │  │
│  │   Menu       │    │  (AuthHelper.isAdmin())                  │  │
│  └──────────────┘    └──────────────────────────────────────────┘  │
│         │                              │                             │
│         │                              ▼                             │
│         │                    ┌──────────────────┐                   │
│         └───────────────────▶│ Show "Admin      │                   │
│                              │ Dashboard" Item  │                   │
│                              └──────────────────┘                   │
│                                       │                              │
│                                       ▼                              │
│              ┌────────────────────────────────────────┐             │
│              │    Admin Dashboard Page                │             │
│              │    - Overview Stats                    │             │
│              │    - Quick Actions                     │             │
│              │    - Weekly Metrics                    │             │
│              └────────────────────────────────────────┘             │
│                       │         │         │                         │
│         ┌─────────────┼─────────┼─────────┼─────────┐              │
│         ▼             ▼         ▼         ▼         ▼              │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐             │
│  │  Users   │ │  Jobs    │ │Analytics │ │  Agents  │             │
│  │  Page    │ │  Page    │ │  Page    │ │  (TBD)   │             │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘             │
│       │             │             │                                 │
└───────┼─────────────┼─────────────┼─────────────────────────────────┘
        │             │             │
        ▼             ▼             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      ADMIN SERVICE LAYER                             │
│  (lib/services/admin_service.dart)                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  • getDashboardStats()          • getUserGrowthStats()              │
│  • getAllUsers()                • getJobPostingStats()              │
│  • updateUserStatus()           • getApplicationStats()             │
│  • deleteUser()                 • getAllAgents()                    │
│  • getAllJobs()                                                      │
│  • updateJobStatus()                                                 │
│  • deleteJob()                                                       │
│                                                                       │
│  Authentication: Bearer Token in Headers                            │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
                                │
                                │ HTTP Requests
                                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         BACKEND API                                  │
│  (Node.js + Express)                                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Route: /api/admin/*                                                │
│                                                                       │
│  Middleware Chain:                                                   │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐         │
│  │ verifyToken  │───▶│ verifyAdmin  │───▶│ Controller   │         │
│  │ (Auth check) │    │ (Admin check)│    │ Function     │         │
│  └──────────────┘    └──────────────┘    └──────────────┘         │
│                                                  │                   │
│  Admin Controller Functions:                    │                   │
│  • getDashboardStats()                           │                   │
│  • getAllUsers()                                 │                   │
│  • getUserById()                                 │                   │
│  • updateUserStatus()                            │                   │
│  • deleteUserById()                              │                   │
│  • getAllJobsAdmin()                             │                   │
│  • updateJobStatus()                             │                   │
│  • deleteJobById()                               │                   │
│  • getAllApplications()                          │                   │
│  • getAllAgents()                                │                   │
│  • getUserGrowthStats()                          ▼                   │
│  • getJobPostingStats()                  ┌──────────────┐          │
│  • getApplicationStats()                 │   MongoDB    │          │
│                                          │   Database   │          │
└──────────────────────────────────────────┴──────────────┴──────────┘
                                                  │
                                                  │
                                    ┌─────────────┴──────────────┐
                                    │                            │
                              ┌─────▼─────┐            ┌────────▼────────┐
                              │   Users   │            │      Jobs       │
                              │Collection │            │   Collection    │
                              │           │            │                 │
                              │ • _id     │            │ • _id           │
                              │ • email   │            │ • title         │
                              │ • isAdmin │            │ • company       │
                              │ • isAgent │            │ • hiring        │
                              └───────────┘            └─────────────────┘
                                    │
                          ┌─────────┴──────────┐
                          │                    │
                   ┌──────▼──────┐    ┌───────▼────────┐
                   │Applications │    │   Bookmarks    │
                   │ Collection  │    │   Collection   │
                   └─────────────┘    └────────────────┘


SECURITY FLOW:
═══════════════

1. User Login ──▶ Receive JWT Token ──▶ Store in SharedPreferences

2. Admin Request:
   ┌──────────────────────────────────────────────────────────┐
   │ Flutter App                                              │
   │   └─▶ Add "Bearer {token}" to request headers           │
   │       └─▶ Send to /api/admin/*                           │
   └──────────────────────────────────────────────────────────┘
                           │
                           ▼
   ┌──────────────────────────────────────────────────────────┐
   │ Backend Middleware                                       │
   │   1. verifyToken: Decode JWT, extract user ID           │
   │   2. verifyAdmin: Query DB for user.isAdmin             │
   │   3. If both pass ──▶ Execute controller                │
   │   4. If either fails ──▶ Return 401/403 error           │
   └──────────────────────────────────────────────────────────┘


DATA FLOW EXAMPLE - View Users:
═══════════════════════════════

User Taps "Manage Users"
    │
    ▼
AdminUsersPage loads
    │
    ▼
Calls: adminService.getAllUsers(page: 1)
    │
    ▼
HTTP GET: /api/admin/users?page=1&limit=20
    │
    ▼
Backend receives request
    │
    ├─▶ verifyToken ✓
    ├─▶ verifyAdmin ✓
    └─▶ adminController.getAllUsers()
            │
            ▼
        Query MongoDB:
        User.find({ isAdmin: false })
            .limit(20)
            .skip(0)
            │
            ▼
        Return user list
            │
            ▼
    HTTP Response: { users: [...], totalPages: 5 }
            │
            ▼
    AdminService parses JSON
            │
            ▼
    AdminUsersPage displays users in ListView


ADMIN SETUP FLOW:
════════════════

Step 1: Register User Normally
    │
    ▼
Step 2: Run Script or Update DB
    └─▶ node makeAdmin.js add user@email.com
            │
            OR
            │
        db.users.updateOne(
            { email: "user@email.com" },
            { $set: { isAdmin: true } }
        )
            │
            ▼
Step 3: User Logs In
    │
    ▼
Step 4: AuthHelper.isAdmin() checks DB
    │
    ├─▶ Returns true ──▶ Show admin menu
    └─▶ Returns false ──▶ Hide admin menu


FOLDER STRUCTURE:
════════════════

backend/
├── controllers/
│   └── adminController.js      [NEW] All admin logic
├── middleware/
│   └── verifyAdmin.js          [NEW] Admin verification
├── routes/
│   └── admin.js                [NEW] Admin routes
├── makeAdmin.js                [NEW] CLI tool
└── index.js                    [MODIFIED] Added admin route

lib/
├── models/
│   └── admin_models.dart       [NEW] Admin data models
├── services/
│   ├── admin_service.dart      [NEW] Admin API client
│   └── auth_helper.dart        [NEW] Auth utilities
└── views/
    ├── ui/
    │   ├── admin/
    │   │   ├── admin_dashboard_page.dart    [NEW]
    │   │   ├── admin_users_page.dart        [NEW]
    │   │   ├── admin_jobs_page.dart         [NEW]
    │   │   └── admin_analytics_page.dart    [NEW]
    │   └── mainscreen.dart                  [MODIFIED]
    └── common/
        └── drawer/
            └── drawerScreen.dart            [MODIFIED]
```
