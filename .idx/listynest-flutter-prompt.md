# ListyNest Flutter App Development Guide

## Project Overview

**App Name:** ListyNest  
**Website:** listynest.com  
**Platform:** Flutter (iOS & Android)  
**Backend:** Node.js/Express hosted on Render  
**Database:** MongoDB Atlas  
**Frontend Web:** Vercel (for reference)  

---

## Architecture

```
Flutter App (Mobile)
    ↓ HTTP/REST API
Backend API (Render) - https://your-backend.onrender.com
    ↓ Mongoose
MongoDB Atlas Database
```

**Authentication:** JWT tokens (same as web app)  
**Image Hosting:** Cloudinary (URLs from API)  
**State Management:** Provider or Riverpod  

---

## API Endpoints to Integrate

### Base URL
```
Production: https://your-backend.onrender.com/api
Development: http://localhost:5000/api
```

### Authentication Endpoints
- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `POST /auth/logout` - Logout
- `GET /auth/me` - Get current user

### Ads Endpoints
- `GET /ads` - Get all ads (with filters: category, location, price range, search)
- `GET /ads/:id` - Get single ad details
- `POST /ads` - Create new ad (requires auth)
- `PUT /ads/:id` - Update ad (requires auth)
- `DELETE /ads/:id` - Delete ad (requires auth)
- `GET /ads/user/:userId` - Get user's ads
- `POST /ads/:id/favorite` - Toggle favorite (requires auth)
- `POST /ads/:id/report` - Report ad (requires auth)
- `GET /ads/similar` - Get similar ads

### Blog Endpoints
- `GET /blogs/featured` - Get 4 featured blogs (previous, current, 2 upcoming)
- `GET /blogs/:slug` - Get single blog by slug
- `GET /blogs/all` - Get all blogs (admin only)

### Auction Endpoints
- `GET /bids/:auctionId` - Get auction bids
- `POST /bids/:auctionId/place` - Place bid (requires auth)
- `GET /bids/my-bids` - Get user's bids (requires auth)

### User Endpoints
- `GET /user/profile` - Get user profile
- `PUT /user/profile` - Update profile
- `GET /user/favorites` - Get user's favorite ads

### Categories & Locations
- `GET /categories` - Get all categories
- `GET /currencies` - Get all currencies
- `GET /locations/countries` - Get countries
- `GET /locations/states/:country` - Get states by country
- `GET /locations/cities/:state` - Get cities by state

### Upload
- `POST /upload/images` - Upload images to Cloudinary

---

## App Structure

```
lib/
├── main.dart
├── config/
│   ├── api_config.dart          # API base URLs, endpoints
│   ├── theme_config.dart        # App theme colors, fonts
│   └── constants.dart           # App constants
├── models/
│   ├── ad_model.dart            # Ad data model
│   ├── blog_model.dart          # Blog data model
│   ├── user_model.dart          # User data model
│   ├── bid_model.dart           # Bid data model
│   └── category_model.dart      # Category model
├── services/
│   ├── api_service.dart         # Base HTTP client (Dio)
│   ├── auth_service.dart        # Authentication logic
│   ├── ad_service.dart          # Ads API calls
│   ├── blog_service.dart        # Blogs API calls
│   ├── upload_service.dart      # Image upload
│   └── storage_service.dart     # Local storage (JWT tokens)
├── providers/
│   ├── auth_provider.dart       # Auth state management
│   ├── ad_provider.dart         # Ads state management
│   ├── blog_provider.dart       # Blogs state management
│   └── filter_provider.dart     # Filter/search state
├── screens/
│   ├── home/
│   │   ├── home_screen.dart     # Main home with blogs + ads grid
│   │   └── widgets/
│   │       ├── blog_hero_section.dart
│   │       ├── ad_card.dart
│   │       └── category_chips.dart
│   ├── search/
│   │   ├── search_screen.dart   # Search & filter page
│   │   └── widgets/
│   │       ├── search_bar.dart
│   │       └── filter_bottom_sheet.dart
│   ├── ad_detail/
│   │   ├── ad_detail_screen.dart
│   │   └── widgets/
│   │       ├── image_gallery.dart
│   │       ├── contact_card.dart
│   │       └── similar_ads.dart
│   ├── post_ad/
│   │   ├── post_ad_screen.dart
│   │   └── widgets/
│   │       ├── category_selector.dart
│   │       ├── image_picker_widget.dart
│   │       └── dynamic_form_fields.dart
│   ├── blog_detail/
│   │   └── blog_detail_screen.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── my_ads_screen.dart
│   │   ├── favorites_screen.dart
│   │   └── my_bids_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   └── settings/
│       └── settings_screen.dart
├── widgets/
│   ├── custom_app_bar.dart
│   ├── loading_widget.dart
│   ├── error_widget.dart
│   ├── empty_state_widget.dart
│   └── custom_button.dart
└── utils/
    ├── helpers.dart             # Helper functions
    ├── validators.dart          # Form validators
    └── date_formatter.dart      # Date formatting
```

---

## Screen Requirements

### 1. Home Screen
**Features:**
- Blog hero section at top (auto-rotating featured blogs)
- "Scroll down to see ads" hint with animation
- Responsive ads grid:
  - Mobile: 2 columns
  - Tablet: 3-4 columns
- Category filter chips (horizontal scroll)
- Location quick filter
- Pull-to-refresh
- Infinite scroll for ads
- Floating action button for "Post Ad"

**UI Elements:**
- AppBar with logo, search icon, notification icon
- Blog carousel with dots indicator
- Category chips with icons
- Ad cards with image, title, price, location
- Bottom navigation bar

---

### 2. Search & Filter Screen
**Features:**
- Search bar at top
- Recent searches
- Filter options:
  - Category (dropdown)
  - Location (Country → State → City)
  - Price range (min/max sliders)
  - Condition (New/Used)
  - Date posted (Today, This week, This month)
  - Sort by (Newest, Price Low-High, Price High-Low)
- Apply filters button
- Clear filters button
- Results count
- Filtered ads grid

**UI Elements:**
- Search TextField with debounce
- Filter chips showing active filters
- Bottom sheet for detailed filters
- Results grid

---

### 3. Ad Detail Screen
**Features:**
- Image gallery (swipeable, pinch-to-zoom)
- Title, price, currency
- Category badge
- Location with map icon
- Posted date, views count
- Full description
- Category-specific details (dynamic)
- External links (if provided)
- Seller contact (email, phone, WhatsApp buttons)
- Favorite button
- Share button (native share)
- Report button
- Similar ads section at bottom
- **For Auctions:**
  - Current bid display
  - Bid history
  - Place bid input
  - Countdown timer
  - Winner notification (if auction ended)

**UI Elements:**
- PageView for images
- Contact action buttons
- Expandable description
- Similar ads horizontal scroll
- Floating share button

---

### 4. Post Ad Screen
**Features:**
- Category selection (required)
- Dynamic form fields based on category
- Title input
- Description (multiline)
- Currency selector
- Price input (hide for Jobs, Events, etc.)
- Location selectors (Country → State → City)
- Image picker (multiple images, max 4)
  - Take photo from camera
  - Select from gallery
  - Image preview with delete option
- Image URL input (optional, 4 fields)
- External links (2 optional fields)
- Contact email & phone
- Ad duration selector
- Preview button
- Submit button
- **For Auctions:**
  - Starting bid
  - Reserve price (optional)
  - Auction end date/time picker
  - Currency selector

**UI Elements:**
- Step indicator (if multi-step form)
- Image grid with add/remove
- Dropdown selectors
- Date/time pickers
- Form validation
- Success dialog after posting
- "Pending review" message

---

### 5. Profile/My Account Screen (Hamburger Menu)
**Features:**
- User profile section (avatar, name, email, member since)
- My Ads (list with status: active, pending, expired, sold)
- My Favorites
- My Bids (for auctions)
- Settings
- Help & Support
- About
- Logout

**Menu Items:**
- Profile
- My Ads
- My Favorites
- My Bids
- Post an Ad (quick action)
- Settings
- Help Center
- Terms & Conditions
- Privacy Policy
- Rate App
- Share App
- Logout

---

### 6. Blog Detail Screen
**Features:**
- Featured image
- Blog title
- Author, date, views
- Full HTML content (rendered with flutter_html)
- Share button
- Related blogs at bottom
- Back button

**UI Elements:**
- Hero image
- HTML content renderer
- Floating share button
- Related blogs cards

---

## Bottom Navigation Bar

```
┌─────────┬─────────┬─────────┬─────────┬─────────┐
│  Home   │ Search  │ Post Ad │ Profile │  Menu   │
│   🏠    │   🔍    │    ➕   │   👤   │   ☰    │
└─────────┴─────────┴─────────┴─────────┴─────────┘
```

---

## Technical Requirements

### Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # HTTP & API
  dio: ^5.4.0
  http: ^1.1.2
  
  # Local Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # Image Handling
  image_picker: ^1.0.7
  cached_network_image: ^3.3.1
  photo_view: ^0.14.0
  
  # UI Components
  flutter_svg: ^2.0.9
  shimmer: ^3.0.0
  pull_to_refresh: ^2.0.0
  carousel_slider: ^4.2.1
  
  # Forms
  flutter_form_builder: ^9.1.1
  
  # Date/Time
  intl: ^0.19.0
  
  # HTML Rendering (for blogs)
  flutter_html: ^3.0.0-beta.2
  
  # URL Launcher (for external links)
  url_launcher: ^6.2.4
  
  # Share
  share_plus: ^7.2.2
  
  # Location/Maps (optional)
  geolocator: ^11.0.0
  google_maps_flutter: ^2.5.3
  
  # Animations
  lottie: ^3.0.0
  
  # Utilities
  connectivity_plus: ^5.0.2
  permission_handler: ^11.2.0
```

---

## Data Models

### Ad Model
```dart
class Ad {
  final String id;
  final String title;
  final String description;
  final double? price;
  final String? currency;
  final String category;
  final Location location;
  final List<AdImage> images;
  final String userId;
  final User? user;
  final String? contactEmail;
  final String? contactPhone;
  final Links? links;
  final String status;
  final bool isFeatured;
  final int views;
  final List<String> favoritedBy;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? auctionDetails;
  final Map<String, dynamic>? details;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    this.currency,
    required this.category,
    required this.location,
    required this.images,
    required this.userId,
    this.user,
    this.contactEmail,
    this.contactPhone,
    this.links,
    required this.status,
    required this.isFeatured,
    required this.views,
    required this.favoritedBy,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.auctionDetails,
    this.details,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: json['price']?.toDouble(),
      currency: json['currency'],
      category: json['category'],
      location: Location.fromJson(json['location']),
      images: (json['images'] as List?)
          ?.map((e) => AdImage.fromJson(e))
          .toList() ?? [],
      userId: json['user'] is String ? json['user'] : json['user']['_id'],
      user: json['user'] is Map ? User.fromJson(json['user']) : null,
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      status: json['status'],
      isFeatured: json['isFeatured'] ?? false,
      views: json['views'] ?? 0,
      favoritedBy: List<String>.from(json['favoritedBy'] ?? []),
      expiresAt: DateTime.parse(json['expiresAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      auctionDetails: json['auctionDetails'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'category': category,
      'location': location.toJson(),
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'links': links?.toJson(),
      'details': details,
      'auctionDetails': auctionDetails,
    };
  }
}

class Location {
  final String country;
  final String state;
  final String city;

  Location({
    required this.country,
    required this.state,
    required this.city,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'],
      state: json['state'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'state': state,
      'city': city,
    };
  }
}

class AdImage {
  final String url;
  final String? publicId;
  final int? order;

  AdImage({
    required this.url,
    this.publicId,
    this.order,
  });

  factory AdImage.fromJson(Map<String, dynamic> json) {
    return AdImage(
      url: json['url'],
      publicId: json['publicId'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'publicId': publicId,
      'order': order,
    };
  }
}
```

### Blog Model
```dart
class Blog {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String authorId;
  final User? author;
  final BlogImage? image;
  final String category;
  final String status;
  final DateTime publishDate;
  final int views;
  final String slug;
  final DateTime createdAt;

  Blog({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.authorId,
    this.author,
    this.image,
    required this.category,
    required this.status,
    required this.publishDate,
    required this.views,
    required this.slug,
    required this.createdAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'],
      title: json['title'],
      excerpt: json['excerpt'],
      content: json['content'],
      authorId: json['author'] is String ? json['author'] : json['author']['_id'],
      author: json['author'] is Map ? User.fromJson(json['author']) : null,
      image: json['image'] != null ? BlogImage.fromJson(json['image']) : null,
      category: json['category'],
      status: json['status'],
      publishDate: DateTime.parse(json['publishDate']),
      views: json['views'] ?? 0,
      slug: json['slug'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class BlogImage {
  final String url;
  final String? publicId;

  BlogImage({required this.url, this.publicId});

  factory BlogImage.fromJson(Map<String, dynamic> json) {
    return BlogImage(
      url: json['url'],
      publicId: json['publicId'],
    );
  }
}
```

### User Model
```dart
class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;
  final DateTime? memberSince;
  final List<String> favorites;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.phone,
    this.memberSince,
    this.favorites = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      phone: json['phone'],
      memberSince: json['memberSince'] != null 
          ? DateTime.parse(json['memberSince']) 
          : null,
      favorites: List<String>.from(json['favorites'] ?? []),
    );
  }
}
```

---

## API Service Example

### config/api_config.dart
```dart
class ApiConfig {
  static const String baseUrl = 'https://your-backend.onrender.com/api';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String ads = '/ads';
  static const String blogs = '/blogs';
  static const String upload = '/upload/images';
  static const String categories = '/categories';
  static const String currencies = '/currencies';
}
```

### services/api_service.dart
```dart
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'storage_service.dart';

class ApiService {
  final Dio _dio;
  final StorageService _storageService;

  ApiService(this._storageService) : _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired, logout user
          _storageService.clearToken();
          // Navigate to login screen
        }
        return handler.next(error);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
```

### services/storage_service.dart
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveUser(String userData) async {
    await _storage.write(key: _userKey, value: userData);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

---

## Authentication Flow

### services/auth_service.dart
```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService(this._apiService, this._storageService);

  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final user = User.fromJson(response.data['user']);

      await _storageService.saveToken(token);
      await _storageService.saveUser(jsonEncode(response.data['user']));

      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<User> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final user = User.fromJson(response.data['user']);

      await _storageService.saveToken(token);
      await _storageService.saveUser(jsonEncode(response.data['user']));

      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/me');
      return User.fromJson(response.data['user']);
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    return token != null;
  }
}
```

---

## Design Guidelines

### Colors (Match Website)
```dart
// config/theme_config.dart
import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF4F46E5); // Indigo-600
  static const secondaryColor = Color(0xFF9333EA); // Purple-600
  static const accentColor = Color(0xFFFBBF24); // Yellow-400
  static const backgroundColor = Color(0xFFF9FAFB); // Gray-50
  static const surfaceColor = Colors.white;
  static const textPrimary = Color(0xFF111827); // Gray-900
  static const textSecondary = Color(0xFF6B7280); // Gray-500
  static const errorColor = Color(0xFFEF4444); // Red-500
  static const successColor = Color(0xFF10B981); // Green-500
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: AppColors.errorColor,
      background: AppColors.backgroundColor,
      surface: AppColors.surfaceColor,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      labelSmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
```

### Spacing
```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
```

---

## Error Handling

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

// Usage in services:
try {
  final response = await _apiService.get('/ads');
  return (response.data['ads'] as List)
      .map((json) => Ad.fromJson(json))
      .toList();
} on DioException catch (e) {
  if (e.response != null) {
    switch (e.response?.statusCode) {
      case 400:
        throw ApiException('Bad request', 400);
      case 401:
        throw ApiException('Unauthorized. Please login.', 401);
      case 404:
        throw ApiException('Not found', 404);
      case 500:
        throw ApiException('Server error. Try again later.', 500);
      default:
        throw ApiException('Something went wrong', e.response?.statusCode);
    }
  } else {
    throw ApiException('No internet connection');
  }
}
```

---

## State Management with Provider

### providers/auth_provider.dart
```dart
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  AuthProvider(this._authService);

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.register(name, email, password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> checkAuth() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
```

---

## Testing Requirements

### Unit Tests
```dart
// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/services/auth_service.dart';

void main() {
  testWidgets('AdCard displays ad information correctly', (WidgetTester tester) async {
    // Test implementation
    final ad = Ad(
      id: '1',
      title: 'Test Ad',
      description: 'Test Description',
      price: 100,
      currency: 'USD',
      category: 'Electronics',
      location: Location(country: 'USA', state: 'CA', city: 'LA'),
      images: [],
      userId: '123',
      status: 'active',
      isFeatured: false,
      views: 0,
      favoritedBy: [],
      expiresAt: DateTime.now().add(Duration(days: 7)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdCard(ad: ad),
        ),
      ),
    );

    expect(find.text('Test Ad'), findsOneWidget);
    expect(find.text('\$100'), findsOneWidget);
  });
}
```

---

## Features Implementation Phases

### Phase 1: MVP (Minimum Viable Product)
**Timeline:** 4-6 weeks

**Features:**
- ✅ Authentication (Login/Register)
- ✅ Home screen with blogs and ads
- ✅ Ad listing with basic filters
- ✅ Ad detail page
- ✅ Search functionality
- ✅ Basic profile (my ads, favorites)
- ✅ Post ad (basic form)
- ✅ Blog detail page

**Deliverables:**
- Working app on Android & iOS
- Basic UI matching website theme
- Core functionality complete
- Alpha testing ready

---

### Phase 2: Enhanced Features
**Timeline:** 3-4 weeks

**Features:**
- ✅ Image upload from camera/gallery
- ✅ Advanced filters (price range, location, date)
- ✅ Push notifications (Firebase Cloud Messaging)
- ✅ Offline mode with caching
- ✅ Share functionality
- ✅ Report ad
- ✅ Edit/delete ads
- ✅ User ratings/reviews
- ✅ Location permissions & map integration

**Deliverables:**
- Enhanced user experience
- Better performance
- Beta testing ready

---

### Phase 3: Advanced Features
**Timeline:** 4-5 weeks

**Features:**
- ✅ Auction bidding system
- ✅ Real-time bid updates (WebSockets or polling)
- ✅ In-app chat between buyer/seller
- ✅ Payment integration (Stripe/PayPal)
- ✅ Ad analytics for sellers
- ✅ Dark mode
- ✅ Multi-language support
- ✅ Social media integration
- ✅ Saved searches with alerts
- ✅ Ad boosting/promotion

**Deliverables:**
- Production-ready app
- App Store & Play Store submission

---

## Deployment

### Android Deployment

**1. Configure app/build.gradle:**
```gradle
android {
    defaultConfig {
        applicationId "com.listynest.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

**2. Generate signed APK/AAB:**
```bash
flutter build appbundle --release
# or
flutter build apk --release --split-per-abi
```

**3. Upload to Google Play Console:**
- Create app listing
- Add screenshots (phone, tablet, 7-inch, 10-inch)
- Write app description
- Set content rating
- Upload AAB file
- Submit for review

---

### iOS Deployment

**1. Configure ios/Runner.xcodeproj:**
- Set Bundle Identifier: `com.listynest.app`
- Set Version & Build number
- Configure signing certificates
- Set deployment target: iOS 12.0+

**2. Generate IPA:**
```bash
flutter build ios --release
```

**3. Upload to App Store Connect:**
- Create app in App Store Connect
- Add app screenshots (6.5", 5.5", 12.9", etc.)
- Write app description
- Set age rating
- Archive and upload via Xcode
- Submit for review

---

## Firebase Integration (Optional)

### Firebase Cloud Messaging (Push Notifications)

**1. Setup Firebase:**
- Create Firebase project
- Add Android app (package: com.listynest.app)
- Add iOS app (bundle ID: com.listynest.app)
- Download `google-services.json` (Android)
- Download `GoogleService-Info.plist` (iOS)

**2. Install packages:**
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9
  flutter_local_notifications: ^16.3.0
```

**3. Initialize Firebase:**
```dart
// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  runApp(MyApp());
}
```

**4. Request permissions & get FCM token:**
```dart
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _fcm.getToken();
      print('FCM Token: $token');
      // Send token to backend
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Show local notification
      }
    });
  }
}
```

**5. Backend integration:**
Send FCM token to backend:
```dart
POST /api/user/fcm-token
Body: { "token": "fcm_token_here" }
```

Backend sends notifications using Firebase Admin SDK when:
- User gets outbid on auction
- Someone favorites their ad
- Ad gets approved/rejected
- New message received

---

## Performance Optimization

### Image Optimization
```dart
// Use cached_network_image for remote images
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(color: Colors.white),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
  fit: BoxFit.cover,
  memCacheWidth: 800, // Resize for memory efficiency
)
```

### Lazy Loading
```dart
// Implement infinite scroll for ads
class AdsListView extends StatefulWidget {
  @override
  _AdsListViewState createState() => _AdsListViewState();
}

class _AdsListViewState extends State<AdsListView> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadAds();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading) {
        _loadMoreAds();
      }
    }
  }

  Future<void> _loadAds() async {
    // Load initial ads
  }

  Future<void> _loadMoreAds() async {
    setState(() => _isLoading = true);
    _page++;
    // Load more ads
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: ads.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == ads.length) {
          return Center(child: CircularProgressIndicator());
        }
        return AdCard(ad: ads[index]);
      },
    );
  }
}
```

### Caching Strategy
```dart
// Cache recent ads offline
class CacheService {
  static const String adsKey = 'cached_ads';
  
  Future<void> cacheAds(List<Ad> ads) async {
    final prefs = await SharedPreferences.getInstance();
    final adsJson = ads.map((ad) => jsonEncode(ad.toJson())).toList();
    await prefs.setStringList(adsKey, adsJson);
  }

  Future<List<Ad>> getCachedAds() async {
    final prefs = await SharedPreferences.getInstance();
    final adsJson = prefs.getStringList(adsKey);
    if (adsJson == null) return [];
    
    return adsJson
        .map((json) => Ad.fromJson(jsonDecode(json)))
        .toList();
  }
}
```

---

## Security Best Practices

### 1. Secure Token Storage
```dart
// Use flutter_secure_storage for JWT tokens
final storage = FlutterSecureStorage();

// Never store tokens in SharedPreferences
await storage.write(key: 'jwt_token', value: token);
```

### 2. API Request Validation
```dart
// Validate all user inputs before sending to API
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}() {
  group('AuthService', () {
    test('login returns user on success', () async {
      // Test implementation
    });

    test('login throws exception on failure', () async {
      // Test implementation
    });
  });
}
```

### Widget Tests
```dart
// test/widgets/ad_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/widgets/ad_card.dart';

void main);
  if (!emailRegex.hasMatch(value)) {
    return 'Invalid email format';
  }
  return null;
}
```

### 3. SSL Pinning (Advanced)
```dart
// For production, implement certificate pinning
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

final dio = Dio();
(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = 
    (client) {
  client.badCertificateCallback = 
      (X509Certificate cert, String host, int port) => false;
  return client;
};
```

### 4. Obfuscate Code
```bash
# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=build/debug-info
```

---

## App Store Optimization (ASO)

### App Name & Description

**App Name:**
"ListyNest - Buy & Sell Locally"

**Short Description (Google Play - 80 chars):**
"Buy, sell, trade locally. Cars, jobs, real estate, electronics & more!"

**Full Description:**

```
ListyNest - Your Local Marketplace for Everything

Buy and sell locally with ease! ListyNest connects buyers and sellers in your area for:

🚗 Vehicles - Cars, motorcycles, boats, RVs
🏠 Real Estate - Houses, apartments, commercial properties
💼 Jobs - Find work or hire talent
📱 Electronics - Phones, laptops, gadgets
🛋️ Home & Garden - Furniture, appliances, decor
👔 Fashion - Clothing, shoes, accessories
📚 Books, Pets, and much more!

✨ KEY FEATURES:
• Browse thousands of local listings
• Advanced search & filters
• Post ads with photos in minutes
• Auction bidding for competitive deals
• Direct contact with sellers
• Save favorite ads
• Real-time notifications
• Safe & secure platform

🎯 WHY LISTYNEST?
• 100% free to browse
• Easy to use interface
• Verified sellers
• Latest blog tips & guides
• Active community

Download now and start buying & selling today!

Questions? Contact us at support@listynest.com
```

**Keywords:**
- classified ads
- buy and sell
- local marketplace
- used cars
- real estate
- jobs near me
- online shopping
- second hand
- auction
- trade

---

## Screenshots Requirements

### Android (Google Play)
- **Phone:** 1080 x 1920px (min 2 screenshots, max 8)
- **7-inch Tablet:** 1024 x 600px
- **10-inch Tablet:** 1280 x 800px

### iOS (App Store)
- **6.5" iPhone:** 1284 x 2778px or 1242 x 2688px
- **5.5" iPhone:** 1242 x 2208px
- **12.9" iPad Pro:** 2048 x 2732px

**Screenshot Ideas:**
1. Home screen with blogs and ads
2. Search & filter interface
3. Ad detail with images
4. Post ad form
5. Profile with my ads
6. Auction bidding screen
7. Chat/messaging (if available)
8. Success stories/testimonials

---

## Monitoring & Analytics

### Firebase Analytics
```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Track screen views
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

  // Track ad views
  Future<void> logAdView(String adId, String category) async {
    await _analytics.logEvent(
      name: 'view_ad',
      parameters: {
        'ad_id': adId,
        'category': category,
      },
    );
  }

  // Track ad posts
  Future<void> logAdPost(String category) async {
    await _analytics.logEvent(
      name: 'post_ad',
      parameters: {'category': category},
    );
  }

  // Track searches
  Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }
}
```

### Crashlytics
```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Pass all uncaught errors to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}

// Log custom events
FirebaseCrashlytics.instance.log('User logged in');

// Set user identifier
FirebaseCrashlytics.instance.setUserIdentifier(userId);
```

---

## Maintenance & Updates

### Version Management
```yaml
# pubspec.yaml
version: 1.0.0+1
# Format: MAJOR.MINOR.PATCH+BUILD_NUMBER
```

**Versioning Strategy:**
- **MAJOR:** Breaking changes, major redesign
- **MINOR:** New features, non-breaking changes
- **PATCH:** Bug fixes, minor improvements
- **BUILD_NUMBER:** Internal tracking

### CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test
    - run: flutter build apk --release
```

---

## AI Assistant Prompt (For Cursor/Copilot/Firebase)

**Complete Prompt:**

```
Create a Flutter mobile app for ListyNest.com, a classified ads platform.

ARCHITECTURE:
- Backend API: https://your-backend.onrender.com/api (Node.js/Express on Render)
- Database: MongoDB Atlas
- Auth: JWT tokens stored in flutter_secure_storage
- Images: Cloudinary (URLs from API)

TECH STACK:
- State Management: Provider
- HTTP Client: Dio with JWT interceptor
- UI: Material Design 3 matching website (Indigo/Purple theme)
- Image Handling: image_picker, cached_network_image
- Local Storage: shared_preferences, flutter_secure_storage
- HTML Rendering: flutter_html (for blog content)

APP STRUCTURE (lib/):
- config/ (api_config, theme_config, constants)
- models/ (ad_model, blog_model, user_model, bid_model)
- services/ (api_service, auth_service, ad_service, blog_service, storage_service)
- providers/ (auth_provider, ad_provider, blog_provider, filter_provider)
- screens/ (home, search, ad_detail, post_ad, profile, blog_detail, auth)
- widgets/ (custom_app_bar, loading_widget, ad_card, etc.)
- utils/ (helpers, validators, formatters)

SCREENS:
1. HOME: Blog hero (auto-rotate featured blogs) + ads grid (2 cols mobile) + pull-to-refresh + infinite scroll
2. SEARCH: Filter bottom sheet (category, location, price range, date) + results grid
3. AD DETAIL: Image gallery (swipe/zoom) + contact buttons + share + report + favorite + similar ads
4. POST AD: Category selector + dynamic form fields + image picker (camera/gallery) + location selectors + validation
5. PROFILE: My ads + favorites + my bids + settings + logout
6. BLOG DETAIL: HTML content rendering + share + related blogs
7. AUTH: Login/register with validation

AUCTION FEATURES:
- Bid placing with validation
- Bid history list
- Countdown timer
- Winner notification
- Real-time updates (polling every 30s)

API ENDPOINTS:
- GET /ads (filters: category, location, minPrice, maxPrice, search)
- GET /ads/:id
- POST /ads (requires auth)
- GET /blogs/featured (4 blogs: previous, current, 2 upcoming)
- GET /blogs/:slug
- POST /auth/login
- POST /auth/register
- GET /auth/me
- POST /bids/:auctionId/place
- GET /bids/:auctionId
- POST /upload/images

DATA MODELS:
- Ad: id, title, description, price, currency, category, location{country,state,city}, images[], userId, contactEmail, contactPhone, status, views, favoritedBy[], expiresAt, auctionDetails{}, details{}
- Blog: id, title, excerpt, content(HTML), author, image, category, status, publishDate, views, slug
- User: id, name, email, avatar, phone, favorites[]

BOTTOM NAV: Home, Search, Post Ad, Profile, Menu

FEATURES:
- JWT auth with auto-logout on 401
- Offline caching of recent ads
- Image upload from camera/gallery
- Share ads (native share)
- Report ads
- Favorite ads
- Form validation
- Error handling with user-friendly messages
- Pull-to-refresh
- Infinite scroll
- Loading states with shimmer
- Empty states
- Network connectivity check

COLORS:
- Primary: #4F46E5 (Indigo-600)
- Secondary: #9333EA (Purple-600)
- Accent: #FBBF24 (Yellow-400)
- Background: #F9FAFB (Gray-50)
- Text Primary: #111827 (Gray-900)
- Text Secondary: #6B7280 (Gray-500)

Generate complete app with all screens, services, providers, models, and proper error handling.
```

---

## Support & Resources

### Documentation
- Flutter Docs: https://docs.flutter.dev
- Dio Package: https://pub.dev/packages/dio
- Provider: https://pub.dev/packages/provider
- Firebase: https://firebase.google.com/docs/flutter

### Community
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: [flutter] tag
- GitHub Discussions: flutter/flutter

### Backend API Reference
- API Documentation: Create Swagger/OpenAPI docs
- Postman Collection: Share with team
- Backend Repository: Link to GitHub repo

---

## Checklist Before Launch

### Development
- [ ] All screens implemented
- [ ] API integration complete
- [ ] Authentication working
- [ ] Image upload functional
- [ ] Search & filters working
- [ ] Auction bidding implemented
- [ ] Error handling in place
- [ ] Loading states everywhere
- [ ] Offline mode tested

### Testing
- [ ] Unit tests written
- [ ] Widget tests passing
- [ ] Integration tests complete
- [ ] Tested on Android (multiple devices)
- [ ] Tested on iOS (multiple devices)
- [ ] Tested on tablets
- [ ] Performance profiling done
- [ ] Memory leaks checked
- [ ] Network scenarios tested (slow/no connection)

### Design
- [ ] Matches website theme
- [ ] Responsive on all screen sizes
- [ ] Animations smooth (60fps)
- [ ] Images optimized
- [ ] Loading indicators present
- [ ] Empty states designed
- [ ] Error states designed

### Security
- [ ] JWT tokens secured
- [ ] API keys not hardcoded
- [ ] User input validated
- [ ] SSL/TLS enforced
- [ ] Code obfuscated for release

### Store Preparation
- [ ] App icon designed (Android & iOS)
- [ ] Screenshots captured (all sizes)
- [ ] App description written
- [ ] Privacy policy created
- [ ] Terms of service ready
- [ ] Support email set up
- [ ] App website live

### Deployment
- [ ] Android signing configured
- [ ] iOS certificates set up
- [ ] Version number set
- [ ] Release notes written
- [ ] Beta testing complete
- [ ] Google Play listing created
- [ ] App Store listing created
- [ ] Submitted for review

---

## Post-Launch Plan

### Week 1
- Monitor crash reports (Crashlytics)
- Check user reviews
- Respond to feedback
- Fix critical bugs
- Track analytics (installs, active users)

### Week 2-4
- Gather feature requests
- Plan next update
- Optimize performance based on metrics
- A/B test different UI elements
- Improve based on user behavior

### Monthly
- Regular updates with bug fixes
- New features based on feedback
- Marketing campaigns
- App Store Optimization updates
- Performance monitoring

---

## Contact & Support

**Developer Support:**
- Email: dev@listynest.com
- Slack/Discord: [Team channel]
- GitHub Issues: [Repository link]

**User Support:**
- Email: support@listynest.com
- FAQ: listynest.com/faq
- Help Center: listynest.com/help

**Marketing:**
- Social Media: @listynest
- Website: listynest.com
- Blog: listynest.com/blog

---

## License & Legal

**App License:** MIT / Proprietary  
**Privacy Policy:** Required before launch  
**Terms of Service:** Required before launch  
**Data Protection:** GDPR/CCPA compliance if applicable  

---

**END OF DOCUMENTATION**

*This guide provides complete specifications for building the ListyNest Flutter mobile app. Share this with your development team or AI coding assistants for implementation.*() {
  group('AuthService', () {
    test('login returns user on success', () async {
      // Test implementation
    });

    test('login throws exception on failure', () async {
      // Test implementation
    });
  });
}
```

### Widget Tests
```dart
// test/widgets/ad_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/widgets/ad_card.dart';

void main