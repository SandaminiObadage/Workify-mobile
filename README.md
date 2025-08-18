# Workify-Flutter Job Hub App

A full-stack mobile application for job searching and management built with Flutter and Node.js.

## 🚀 Features

- **User Authentication**: Secure registration and login with JWT tokens
- **Job Listings**: Browse and search available job opportunities
- **Profile Management**: User profile with avatar and personal information
- **Bookmark Jobs**: Save interesting job postings for later review
- **Real-time Updates**: Live data synchronization with backend
- **Modern UI**: Clean and intuitive user interface
- **Cross-platform**: Works on both Android and iOS

## 🛠️ Tech Stack

### Frontend (Flutter)
- **Flutter**: 3.22.2
- **Dart**: Latest stable version
- **Firebase Firestore**: Cloud database
- **CachedNetworkImage**: Image caching and loading
- **HTTP**: API communication
- **JWT**: Authentication token handling

### Backend (Node.js)
- **Node.js**: JavaScript runtime
- **Express.js**: Web application framework
- **MongoDB**: NoSQL database
- **JWT**: JSON Web Token authentication
- **CryptoJS**: Password encryption
- **CORS**: Cross-origin resource sharing
- **Multer**: File upload handling

## 📁 Project Structure

```
flutter-job-hub/
├── lib/                    # Flutter app source code
│   ├── constants/          # App constants and configurations
│   ├── controllers/        # State management and business logic
│   ├── models/            # Data models
│   ├── services/          # API services and utilities
│   ├── views/             # UI screens and widgets
│   └── main.dart          # App entry point
├── backend/               # Node.js backend
│   ├── controllers/       # API route handlers
│   ├── middleware/        # Authentication middleware
│   ├── models/           # Database models
│   ├── routes/           # API routes
│   └── index.js          # Server entry point
├── assets/               # Images, icons, and other assets
└── android/              # Android platform specific files
```

## 🔧 Installation & Setup

### Prerequisites
- Flutter SDK (3.22.2+)
- Node.js (v14+)
- MongoDB
- Android Studio / VS Code
- Git

### Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file with your configurations:
   ```env
   MONGODB_URL=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret_key
   PORT=5002
   ```

4. Start the server:
   ```bash
   npm start
   ```
   The server will run on `http://localhost:5002`

### Flutter Setup
1. Make sure Flutter is installed and configured
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase (optional):
   - Update `firebase_options.dart` with your Firebase config

4. Update API endpoint in `lib/services/config.dart`:
   ```dart
   static const String apiUrl = "http://YOUR_IP:5002";
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## 🔑 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login

### Users
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/` - Update user profile

### Jobs
- `GET /api/jobs/` - Get all jobs
- `POST /api/jobs/` - Create new job
- `GET /api/jobs/:id` - Get specific job

### Bookmarks
- `GET /api/bookmarks/` - Get user bookmarks
- `POST /api/bookmarks/` - Add bookmark
- `DELETE /api/bookmarks/:id` - Remove bookmark

## 🎯 Key Features Implemented

### ✅ Working Features
- User registration and authentication
- Profile page with user information
- Job listings and browsing
- Bookmark functionality
- Image loading with fallback avatars
- Real-time data synchronization
- Cross-platform compatibility

### 🔧 Recent Fixes
- Fixed profile page List/Map type error
- Updated image URLs for better reliability
- Resolved backend routing conflicts
- Improved error handling
- Enhanced UI/UX

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Express.js community for the robust backend tools
- MongoDB for the flexible database solution
