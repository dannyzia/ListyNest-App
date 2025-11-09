# ListyNest Flutter App - MVP Development Guide

## 🎯 Project Overview

**App Name:** ListyNest  
**Platform:** Flutter (iOS & Android)  
**Architecture:** Firebase Direct (Auth + Firestore)  
**State Management:** Provider  
**Phase:** MVP (Minimum Viable Product)

---

## 🏗️ Architecture (MVP Phase)

```
Flutter App (Mobile)
    ↓
Firebase Authentication (User Auth)
    ↓
Cloud Firestore (Data Storage)
```

**Key Points:**
- ✅ Using Firebase services DIRECTLY (no backend API yet)
- ✅ Simple Provider state management
- ✅ MaterialPageRoute navigation
- ✅ Local image storage (Cloudinary integration later)
- ✅ MVP features only (auction/chat/blogs come later)

---

## 📦 Dependencies (Current MVP)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6

  # State Management
  provider: ^6.1.1

  # UI Components
  cupertino_icons: ^1.0.6
  cached_network_image: ^3.3.1
  image_picker: ^1.0.7

  # Utilities
  url_launcher: ^6.2.4
  share_plus: ^7.2.2
  http: ^1.1.2
  shared_preferences: ^2.2.2
```

**DO NOT USE (Future Phase Only):**
- ❌ dio (for backend API - not needed yet)
- ❌ go_router (using simple navigation)
- ❌ riverpod (using Provider instead)
- ❌ flutter_html (blogs come later)

---

## 📁 App Structure (MVP)

```
lib/
├── main.dart
├── firebase_options.dart
├── config/
│   └── theme_config.dart
├── models/
│   ├── ad.dart                    # Main Ad model
│   ├── category.dart              # Category model
│   ├── user_extensions.dart       # Firebase User extensions
│   └── favorite_model.dart
├── services/
│   └── ad_service.dart            # Firestore operations
├── providers/
│   ├── auth_provider.dart         # Authentication state
│   ├── ad_provider.dart           # Ads state
│   ├── search_provider.dart       # Search/filter state
│   ├── favorite_provider.dart     # Favorites state
│   └── category_provider.dart     # Categories state
├── screens/
│   ├── home/
│   │   └── home_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── ad_detail/
│   │   └── ad_detail_screen.dart
│   ├── post_ad/
│   │   └── post_ad_screen.dart
│   ├── search/
│   │   └── search_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   ├── user/
│   │   └── my_ads_screen.dart
│   └── favorites/
│       └── favorites_screen.dart
├── widgets/
│   └── ad_card.dart
└── router/
    └── app_router.dart
```

---

## 🔥 Firebase Setup

### Firestore Collections Structure

```
ads/
  ├── {adId}/
  │   ├── title: string
  │   ├── description: string
  │   ├── price: number
  │   ├── currency: string
  │   ├── category: string
  │   ├── location: map
  │   │   ├── country: string
  │   │   ├── state: string
  │   │   └── city: string
  │   ├── imageUrls: array[string]
  │   ├── userId: string
  │   ├── contactEmail: string (optional)
  │   ├── contactPhone: string (optional)
  │   ├── status: string (active/pending/expired/sold)
  │   ├── isFeatured: boolean
  │   ├── views: number
  │   ├── favoritedBy: array[userId]
  │   ├── expiresAt: timestamp
  │   ├── createdAt: timestamp
  │   └── updatedAt: timestamp

reports/
  ├── {reportId}/
  │   ├── adId: string
  │   ├── reason: string
  │   └── reportedAt: timestamp
```

### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Ads collection
    match /ads/{adId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Reports collection
    match /reports/{reportId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
    }
  }
}
```

---

## 🎨 Data Models

### Ad Model (Complete)

```dart
class Location {
  final String country;
  final String state;
  final String city;

  Location({
    required this.country,
    required this.state,
    required this.city,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    country: json['country'] ?? '',
    state: json['state'] ?? '',
    city: json['city'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'country': country,
    'state': state,
    'city': city,
  };
}

class Ad {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String category;
  final Location location;
  final List<String> imageUrls;  // ⚠️ NOT 'images'
  final String userId;
  final String? contactEmail;
  final String? contactPhone;
  final String status;
  final bool isFeatured;
  final int views;
  final List<String> favoritedBy;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor, fromJson, toJson methods...
}
```

### User Extensions (Firebase User)

```dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

extension UserExtensions on firebase_auth.User {
  String get id => uid;  // Firebase uses 'uid'
  String get name => displayName ?? email?.split('@')[0] ?? 'User';
  String? get avatarUrl => photoURL;
  String? get phone => phoneNumber;
}
```

---

## 📱 Screen Requirements (MVP)

### 1. Home Screen
- Blog hero section (placeholder for now)
- Ads grid (2 columns mobile)
- Pull-to-refresh
- Category filter chips
- Floating "Post Ad" button

### 2. Ad Detail Screen
- Image gallery (swipeable)
- Title, price, description
- Location, category
- Contact buttons (email, phone)
- Share button
- Report button
- Favorite button

### 3. Post Ad Screen
- Category dropdown
- Title, description fields
- Price + currency
- Location (country, state, city)
- Image picker (up to 4 images)
- Contact info (email, phone)
- Submit button

### 4. Search Screen
- Search bar
- Category filter
- Price range filter
- Results grid

### 5. Profile Screen
- User info
- My Ads
- Favorites
- Edit profile
- Logout

### 6. Auth Screens
- Login (email + password)
- Register (email + password)

---

## 🚀 Navigation

```dart
// Simple MaterialPageRoute navigation
Navigator.pushNamed(context, '/ad-detail', arguments: {'ad': ad});
Navigator.pushNamed(context, '/post-ad');
Navigator.pushReplacementNamed(context, '/');
```

**Routes:**
- `/` - Home
- `/login` - Login
- `/register` - Register
- `/ad-detail` - Ad Detail (requires ad argument)
- `/post-ad` - Post Ad
- `/profile` - Profile
- `/my-ads` - My Ads
- `/favorites` - Favorites
- `/search` - Search

---

## 🎨 Theme (Match Website)

```dart
class AppColors {
  static const primaryColor = Color(0xFF4F46E5);      // Indigo-600
  static const secondaryColor = Color(0xFF9333EA);    // Purple-600
  static const backgroundColor = Color(0xFFF9FAFB);   // Gray-50
  static const textPrimary = Color(0xFF111827);       // Gray-900
  static const textSecondary = Color(0xFF6B7280);     // Gray-500
}
```

---

## ✅ MVP Feature Checklist

### Core Features (Must Have)
- [x] Firebase Authentication (email/password)
- [x] View ads list
- [x] View ad details
- [x] Post new ad with images
- [x] Search ads
- [x] Filter by category
- [x] Filter by price range
- [x] My ads page
- [x] Favorites system
- [x] User profile
- [x] Edit profile
- [x] Contact seller (email/phone)
- [x] Share ad
- [x] Report ad

### NOT in MVP (Future Phases)
- ❌ Backend API integration
- ❌ Auction/bidding system
- ❌ Blogs
- ❌ Chat/messaging
- ❌ Cloudinary image upload
- ❌ Push notifications
- ❌ Maps integration
- ❌ Payment processing
- ❌ Advanced analytics

---

## 🔧 Common Fixes

### 1. Firebase User Access
```dart
// ❌ WRONG
user.id
user.name

// ✅ CORRECT
user.uid
user.displayName ?? 'User'
```

### 2. Ad Image Property
```dart
// ❌ WRONG
ad.images

// ✅ CORRECT
ad.imageUrls
```

### 3. TextTheme
```dart
// ❌ WRONG
Theme.of(context).textTheme.headline6

// ✅ CORRECT
Theme.of(context).textTheme.titleLarge
```

### 4. Register Function
```dart
// ❌ WRONG
authProvider.register(name, email, password)

// ✅ CORRECT
authProvider.register(email, password)
```

---

## 🧪 Testing Checklist

### Build Tests
```bash
flutter pub get
flutter analyze
flutter build apk --debug
```

### Manual Tests
- [ ] App launches without crashes
- [ ] Can register new user
- [ ] Can login existing user
- [ ] Home screen shows ads
- [ ] Can view ad details
- [ ] Can post new ad
- [ ] Can search ads
- [ ] Can filter by category/price
- [ ] Can favorite/unfavorite ads
- [ ] Can view my ads
- [ ] Can view favorites
- [ ] Can edit profile
- [ ] Can logout

---

## 📊 Success Criteria

The MVP is **COMPLETE** when:

1. ✅ Zero compile errors
2. ✅ App builds on Android/iOS
3. ✅ All core features work
4. ✅ Clean code (flutter analyze passes)
5. ✅ Proper error handling
6. ✅ Loading states everywhere
7. ✅ User-friendly messages

---

## 🔄 Migration Path (Future)

**Current (MVP):**
```
Flutter → Firebase Auth/Firestore
```

**Phase 2 (Backend Integration):**
```
Flutter → Node.js API → MongoDB
```

**Changes needed for Phase 2:**
1. Add `dio` package
2. Create API service layer
3. Implement JWT token handling
4. Add Cloudinary image upload
5. Switch from Firestore to API calls
6. Add backend-dependent features (auctions, blogs, chat)

---

## 🎯 Development Guidelines

### Always Use:
- ✅ `ad.dart` (NOT ad_model.dart)
- ✅ Firebase User's `uid` (NOT id)
- ✅ `imageUrls` property (NOT images)
- ✅ `titleLarge` (NOT headline6)
- ✅ Provider for state management
- ✅ Firebase services directly

### Never Use (Yet):
- ❌ Backend API calls
- ❌ Dio HTTP client
- ❌ Complex routing (go_router)
- ❌ WebSockets
- ❌ Advanced state management (Riverpod/Bloc)

### Code Quality:
- Add `const` constructors where possible
- Use `Key? key` parameters
- Follow Flutter linting rules
- Handle errors gracefully
- Show loading indicators
- Display empty states

---

## 📝 AI Assistant Instructions

When helping with this project:

1. **Stick to MVP scope** - No backend API, no complex features
2. **Use Firebase directly** - No HTTP calls to backend
3. **Keep it simple** - Provider, basic navigation
4. **Follow fix-problem.md** - Not listynest-flutter-prompt.md
5. **Focus on core features** - Authentication, CRUD ads, search, favorites
6. **Use current dependencies** - Don't add dio, go_router, etc.
7. **Test incrementally** - Make sure each phase works before moving on

---

## 🆘 Support

For issues:
1. Check `fix-problem.md` for troubleshooting steps
2. Run `flutter clean && flutter pub get`
3. Check Firebase console for data
4. Use `flutter analyze` to find errors

---

**END OF MVP GUIDE**

*This guide is for the Firebase-based MVP only. Backend API integration will be a separate phase.*