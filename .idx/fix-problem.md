PHASE 1: Delete Conflicting Files
Step 1.1: Delete duplicate Ad model
bash# Delete this file completely:
rm lib/models/ad_model.dart

# Keep only:
# lib/models/ad.dart
Step 1.2: Delete broken screens and widgets
bash# Delete these entire folders/files:
rm -rf lib/screens/ads/
rm -rf lib/screens/bids/
rm -rf lib/screens/conversations/
rm lib/screens/blog/blog_details_screen.dart
rm lib/screens/home/widgets/real_time_bidding_card.dart
rm lib/screens/home/widgets/real_time_bidding_section.dart
rm lib/widgets/blog_hero_section.dart
rm lib/widgets/auction_card.dart
rm lib/widgets/notification_card.dart
rm lib/widgets/review_card.dart
rm lib/widgets/main_navigation.dart
Step 1.3: Delete providers/services referencing missing models
bash# Delete or comment out:
rm lib/providers/auction_provider.dart
rm lib/services/bidding_service.dart
rm lib/services/bids_service.dart
rm lib/services/blog_service.dart

PHASE 2: Fix Core Models
Step 2.1: Create correct Ad model
dart// lib/models/ad.dart
import 'package:cloud_firestore/cloud_firestore.dart';

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
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'country': country,
    'state': state,
    'city': city,
  };

  @override
  String toString() => '$city, $state, $country';
}

class Ad {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String category;
  final Location location;
  final List<String> imageUrls; // ⚠️ NOT 'images'
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

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.category,
    required this.location,
    required this.imageUrls,
    required this.userId,
    this.contactEmail,
    this.contactPhone,
    required this.status,
    this.isFeatured = false,
    this.views = 0,
    this.favoritedBy = const [],
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      category: json['category'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      imageUrls: List<String>.from(json['images'] ?? json['imageUrls'] ?? []),
      userId: json['user'] is String ? json['user'] : (json['user']?['_id'] ?? json['userId'] ?? ''),
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      status: json['status'] ?? 'active',
      isFeatured: json['isFeatured'] ?? false,
      views: json['views'] ?? 0,
      favoritedBy: List<String>.from(json['favoritedBy'] ?? []),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt']) 
          : DateTime.now().add(Duration(days: 30)),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  factory Ad.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Ad.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'price': price,
    'currency': currency,
    'category': category,
    'location': location.toJson(),
    'imageUrls': imageUrls,
    'userId': userId,
    'contactEmail': contactEmail,
    'contactPhone': contactPhone,
    'status': status,
    'isFeatured': isFeatured,
    'views': views,
    'favoritedBy': favoritedBy,
    'expiresAt': expiresAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
Step 2.2: Create User extension for Firebase User
dart// lib/models/user_extensions.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

extension UserExtensions on firebase_auth.User {
  String get id => uid; // Firebase User uses 'uid', not 'id'
  String get name => displayName ?? email?.split('@')[0] ?? 'User';
  String? get avatarUrl => photoURL;
  String? get phone => phoneNumber;
}
Step 2.3: Fix Category model
dart// lib/models/category.dart
class Category {
  final String id;
  final String name;
  final String? icon;

  Category({
    required this.id,
    required this.name,
    this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'],
    );
  }

  @override
  String toString() => name;
}

PHASE 3: Fix Services
Step 3.1: Fix AdService
dart// lib/services/ad_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ad.dart';

class AdService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Fetch ads with filters
  Future<List<Ad>> fetchAds({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      Query query = _firestore.collection('ads');

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }
      
      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }
      
      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      final snapshot = await query.get();
      
      List<Ad> ads = snapshot.docs
          .map((doc) => Ad.fromFirestore(doc))
          .toList();

      // Apply search filter in-memory if provided
      if (search != null && search.isNotEmpty) {
        ads = ads.where((ad) => 
          ad.title.toLowerCase().contains(search.toLowerCase()) ||
          ad.description.toLowerCase().contains(search.toLowerCase())
        ).toList();
      }

      return ads;
    } catch (e) {
      throw Exception('Failed to fetch ads: $e');
    }
  }

  // ✅ Get single ad by ID
  Future<Ad?> getAdById(String id) async {
    try {
      final doc = await _firestore.collection('ads').doc(id).get();
      if (!doc.exists) return null;
      return Ad.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch ad: $e');
    }
  }

  // ✅ Create new ad
  Future<void> createAd(Ad ad) async {
    try {
      await _firestore.collection('ads').add(ad.toJson());
    } catch (e) {
      throw Exception('Failed to create ad: $e');
    }
  }

  // ✅ Update ad
  Future<void> updateAd(String id, Ad ad) async {
    try {
      await _firestore.collection('ads').doc(id).update(ad.toJson());
    } catch (e) {
      throw Exception('Failed to update ad: $e');
    }
  }

  // ✅ Delete ad
  Future<void> deleteAd(String id) async {
    try {
      await _firestore.collection('ads').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete ad: $e');
    }
  }

  // ✅ Get user's ads
  Future<List<Ad>> fetchUserAds(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('ads')
          .where('userId', isEqualTo: userId)
          .get();
      
      return snapshot.docs.map((doc) => Ad.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user ads: $e');
    }
  }

  // ✅ Toggle favorite
  Future<void> toggleFavorite(String adId, String userId) async {
    try {
      final docRef = _firestore.collection('ads').doc(adId);
      final doc = await docRef.get();
      
      if (!doc.exists) return;
      
      List<String> favoritedBy = List<String>.from(doc.data()?['favoritedBy'] ?? []);
      
      if (favoritedBy.contains(userId)) {
        favoritedBy.remove(userId);
      } else {
        favoritedBy.add(userId);
      }
      
      await docRef.update({'favoritedBy': favoritedBy});
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  // ✅ Get favorite ads
  Future<List<Ad>> fetchFavorites(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('ads')
          .where('favoritedBy', arrayContains: userId)
          .get();
      
      return snapshot.docs.map((doc) => Ad.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch favorites: $e');
    }
  }

  // ✅ Report ad
  Future<void> reportAd(String adId, String reason) async {
    try {
      await _firestore.collection('reports').add({
        'adId': adId,
        'reason': reason,
        'reportedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to report ad: $e');
    }
  }
}

PHASE 4: Fix Providers
Step 4.1: Fix AuthProvider
dart// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  firebase_auth.User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  firebase_auth.User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }
  
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> checkAuth() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> updateUser(String name, String? phone) async {
    try {
      await _user?.updateDisplayName(name);
      // Phone update would need Firebase Phone Auth setup
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
Step 4.2: Fix AdProvider
dart// lib/providers/ad_provider.dart
import 'package:flutter/foundation.dart';
import '../models/ad.dart';
import '../services/ad_service.dart';

class AdProvider with ChangeNotifier {
  final AdService _adService = AdService();
  
  List<Ad> _ads = [];
  Ad? _selectedAd;
  bool _isLoading = false;
  String? _errorMessage;
  
  List<Ad> get ads => _ads;
  Ad? get selectedAd => _selectedAd;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // ✅ Fetch all ads
  Future<void> fetchAds({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _ads = await _adService.fetchAds(
        category: category,
        search: search,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Fetch ad by ID
  Future<void> fetchAdById(String id) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _selectedAd = await _adService.getAdById(id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // ✅ Post new ad
  Future<void> postAd(Ad ad) async {
    try {
      await _adService.createAd(ad);
      await fetchAds(); // Refresh list
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ✅ Fetch user's ads
  Future<void> fetchUserAds(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _ads = await _adService.fetchUserAds(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Fetch favorites
  Future<void> fetchFavorites(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _ads = await _adService.fetchFavorites(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Toggle favorite
  Future<void> toggleFavorite(String adId, String userId) async {
    try {
      await _adService.toggleFavorite(adId, userId);
      await fetchAds(); // Refresh
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ✅ Report ad
  Future<void> reportAd(String adId, String reason) async {
    try {
      await _adService.reportAd(adId, reason);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}

PHASE 5: Fix Import Statements
Step 5.1: Update all files importing ad_model.dart
Use this find-and-replace across the entire project:
Find:
dartimport 'package:listynest/models/ad_model.dart';
import '../models/ad_model.dart';
import '../../models/ad_model.dart';
Replace with:
dartimport 'package:listynest/models/ad.dart';
import '../models/ad.dart';
import '../../models/ad.dart';
Affected files (do this for ALL):

lib/models/favorite_model.dart
lib/providers/search_provider.dart
lib/screens/ad_detail/ad_detail_screen.dart
lib/widgets/ad_card.dart
lib/widgets/add_ad_form.dart
All other files with ad_model imports


PHASE 6: Fix Common Errors
Step 6.1: Fix Firebase User property access
Find and replace throughout project:
dart// ❌ WRONG:
user.id
user.name
user.avatarUrl

// ✅ CORRECT:
user.uid
user.displayName ?? 'User'
user.photoURL
Step 6.2: Fix deprecated TextTheme properties
Find:
dartTheme.of(context).textTheme.headline6
Replace with:
dartTheme.of(context).textTheme.titleLarge
Step 6.3: Fix register function calls
Find:
dartauthProvider.register(name, email, password)
Replace with:
dartauthProvider.register(email, password)
Step 6.4: Fix Ad property access (images → imageUrls)
Find:
dartad.images
Replace with:
dartad.imageUrls
Step 6.5: Remove const from non-const constructors
Find patterns like:
dartconst HomeScreen()
const ProfileScreen()
const LoginScreen()
Replace with:
dartHomeScreen()
ProfileScreen()
LoginScreen()

PHASE 7: Fix Specific Screens
Step 7.1: Fix SearchProvider
dart// lib/providers/search_provider.dart
import 'package:flutter/foundation.dart';
import '../models/ad.dart';
import '../models/category.dart';
import '../services/ad_service.dart';

class SearchProvider with ChangeNotifier {
  final AdService _adService = AdService();
  
  List<Ad> _results = [];
  String? _searchQuery;
  String? _selectedCategory; // Change from Category? to String?
  double? _minPrice;
  double? _maxPrice;
  bool _isLoading = false;
  
  List<Ad> get results => _results;
  String? get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  
  Future<void> search({
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    _searchQuery = query;
    _selectedCategory = category;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _isLoading = true;
    notifyListeners();
    
    try {
      _results = await _adService.fetchAds(
        search: query,
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearFilters() {
    _searchQuery = null;
    _selectedCategory = null;
    _minPrice = null;
    _maxPrice = null;
    _results = [];
    notifyListeners();
  }
}
Step 7.2: Fix FavoriteProvider
dart// lib/providers/favorite_provider.dart
import 'package:flutter/foundation.dart';
import '../models/ad.dart';
import '../services/ad_service.dart';

class FavoriteProvider with ChangeNotifier {
  final AdService _adService = AdService();
  List<Ad> _favorites = [];
  bool _isLoading = false;
  
  List<Ad> get favorites => _favorites;
  bool get isLoading => _isLoading;
  
  Future<void> loadFavorites(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _favorites = await _adService.fetchFavorites(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> toggleFavorite(String adId, String userId) async {
    try {
      await _adService.toggleFavorite(adId, userId);
      await loadFavorites(userId);
    } catch (e) {
      rethrow;
    }
  }
  
  bool isFavorite(String adId) {
    return _favorites.any((ad) => ad.id == adId);
  }
}

PHASE 8: Clean Up Router
Step 8.1: Fix app_router.dart
dart// lib/router/app_router.dart (or lib/app_router.dart)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/ad_detail/ad_detail_screen.dart';
import 'screens/post_ad/post_ad_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/user/my_ads_screen.dart';
import 'screens/favorites/favorites_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      
      case '/ad-detail':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AdDetailScreen(ad: args['ad']),
        );
      
      case '/post-ad':
        return MaterialPageRoute(builder: (_) => PostAdScreen());
      
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      
      case '/my-ads':
        return MaterialPageRoute(builder: (_) => MyAdsScreen());
      
      case '/favorites':
        return MaterialPageRoute(builder: (_) => FavoritesScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}

PHASE 9: Fix main.dart
dart// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/ad_provider.dart';
import 'providers/search_provider.dart';
import 'providers/favorite_provider.dart';
import 'router/app_router.dart';
import 'config/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        title: 'ListyNest',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}

PHASE 10: Remove Lint Warnings (Optional but Recommended)
Step 10.1: Fix missing constructors
Add Key? key parameter and call super(key: key) for all StatelessWidget/StatefulWidget:
dart// ❌ Before:
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {...}
}

// ✅ After:
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {...}
}
Step 10.2: Fix public/private class warnings
dart// ❌ Before:
class _MyWidgetState extends State<MyWidget> {
  // Public class using private name
}

// ✅ After: Make class name match convention or make parent private
class MyWidgetState extends State<MyWidget> {
  // Or make MyWidget private: class _MyWidget
}

🧪 TESTING CHECKLIST
After all fixes, test in this order:
1. Build Check
bashflutter pub get
flutter analyze
flutter build apk --debug
2. Manual Testing

 App launches without crashes
 Can navigate to Login screen
 Can register new user
 Can login existing user
 Home screen shows ads list (or empty state)
 Can tap on an ad to see details
 Can navigate to Post Ad screen
 Can logout from profile

3. Expected Working Features

✅ Authentication (Firebase Auth)
✅ View ads list
✅ View ad details
✅ Post new ad (basic form)
✅ View user profile
✅ View my ads
✅ Favorite ads
✅ Basic search

4. Known Limitations (To Implement Later)

❌ Auction/Bidding
❌ Blogs
❌ Chat/Messages
❌ Image upload to Cloudinary
❌ Advanced filters
❌ Push notifications


🚨 CRITICAL RULES

DO NOT create any files related to:

Auctions
Bidding
Blogs
Conversations/Chat
Real-time features


ALWAYS use:

ad.dart (NOT ad_model.dart)
Firebase User's uid (NOT id)
imageUrls property (NOT images)
titleLarge (NOT headline6)


FIREBASE AUTH ONLY:

Use Firebase Authentication for users
Use Firestore for ads data
No backend API calls (yet)


KEEP IT SIMPLE:

Focus on core CRUD operations
Use basic UI with Material widgets
Add fancy features AFTER basics work




📝 VERIFICATION
After completing all phases, verify:
bash# Should have ZERO errors:
flutter analyze

# Should list only these providers:
# - AuthProvider
# - AdProvider  
# - SearchProvider
# - FavoriteProvider

# Should NOT have these files:
# - lib/models/ad_model.dart
# - lib/providers/auction_provider.dart
# - lib/services/bidding_service.dart
# - lib/widgets/real_time_bidding_card.dart
```

---

## 🎯 SUCCESS CRITERIA

The app is fixed when:
1. ✅ Zero compile errors (`flutter analyze` clean)
2. ✅ App builds successfully
3. ✅ Can login/register
4. ✅ Can view ads list
5. ✅ Can view ad details
6. ✅ Can create new ad
7. ✅ Can view profile

**Ignore all linter warnings** (yellow warnings) for now - focus on red errors only.

---

## 🆘 IF STILL BROKEN

If after all fixes there are still >50 errors, recommend:

1. **Start fresh with this structure:**
```
lib/
├── main.dart
├── models/
│   └── ad.dart (only this one)
├── services/
│   └── ad_service.dart
├── providers/
│   ├── auth_provider.dart
│   └── ad_provider.dart
├── screens/
│   ├── home/
│   ├── auth/
│   └── profile/

Copy working code from phases above
**Ignore everything else

PHASE 11: Fix Core Screens
Step 11.1: Fix HomeScreen
dart// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ad_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/ad.dart';
import '../widgets/ad_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load ads when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdProvider>().fetchAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adProvider = context.watch<AdProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('ListyNest'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(authProvider.user?.displayName ?? 'Guest'),
              accountEmail: Text(authProvider.user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: authProvider.user?.photoURL != null
                    ? NetworkImage(authProvider.user!.photoURL!)
                    : null,
                child: authProvider.user?.photoURL == null
                    ? Icon(Icons.person)
                    : null,
              ),
            ),
            if (authProvider.isLoggedIn) ...[
              ListTile(
                leading: Icon(Icons.add_circle),
                title: Text('Post Ad'),
                onTap: () => Navigator.pushNamed(context, '/post-ad'),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('My Ads'),
                onTap: () => Navigator.pushNamed(context, '/my-ads'),
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () => Navigator.pushNamed(context, '/favorites'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  await authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ] else ...[
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Login'),
                onTap: () => Navigator.pushNamed(context, '/login'),
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text('Register'),
                onTap: () => Navigator.pushNamed(context, '/register'),
              ),
            ],
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => adProvider.fetchAds(),
        child: adProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : adProvider.errorMessage != null
                ? Center(child: Text('Error: ${adProvider.errorMessage}'))
                : adProvider.ads.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No ads yet', style: TextStyle(fontSize: 18)),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/post-ad'),
                              child: Text('Post First Ad'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: adProvider.ads.length,
                        itemBuilder: (context, index) {
                          return AdCard(ad: adProvider.ads[index]);
                        },
                      ),
      ),
      floatingActionButton: authProvider.isLoggedIn
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/post-ad'),
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
Step 11.2: Create AdCard Widget
dart// lib/screens/widgets/ad_card.dart (or lib/widgets/ad_card.dart)
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/ad.dart';

class AdCard extends StatelessWidget {
  final Ad ad;

  const AdCard({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/ad-detail',
          arguments: {'ad': ad},
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: ad.imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: ad.imageUrls.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.error, size: 40),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
                      ),
              ),
            ),
            // Details
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${ad.currency} ${ad.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          ad.location.city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Step 11.3: Fix AdDetailScreen
dart// lib/screens/ad_detail/ad_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/ad.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ad_provider.dart';

class AdDetailScreen extends StatelessWidget {
  final Ad ad;

  const AdDetailScreen({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final adProvider = context.read<AdProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('Check out this ad: ${ad.title} - ${ad.currency} ${ad.price}');
            },
          ),
          IconButton(
            icon: Icon(Icons.report),
            onPressed: () => _showReportDialog(context, adProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            if (ad.imageUrls.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: ad.imageUrls.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: ad.imageUrls[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  },
                ),
              )
            else
              Container(
                height: 300,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
              ),

            // Content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    ad.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Price
                  Text(
                    '${ad.currency} ${ad.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        '${ad.location.city}, ${ad.location.state}, ${ad.location.country}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Category
                  Chip(
                    label: Text(ad.category),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  SizedBox(height: 16),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    ad.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),

                  // Contact Buttons
                  if (ad.contactEmail != null || ad.contactPhone != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Seller',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        if (ad.contactEmail != null)
                          ElevatedButton.icon(
                            onPressed: () => _launchEmail(ad.contactEmail!),
                            icon: Icon(Icons.email),
                            label: Text('Email Seller'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48),
                            ),
                          ),
                        if (ad.contactPhone != null) ...[
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _launchPhone(ad.contactPhone!),
                            icon: Icon(Icons.phone),
                            label: Text('Call Seller'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48),
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: authProvider.isLoggedIn
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    adProvider.toggleFavorite(ad.id, authProvider.user!.uid);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Favorite toggled')),
                    );
                  },
                  icon: Icon(Icons.favorite_border),
                  label: Text('Add to Favorites'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Inquiry about ${ad.title}',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _showReportDialog(BuildContext context, AdProvider adProvider) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Ad'),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            hintText: 'Enter reason for reporting',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.isNotEmpty) {
                await adProvider.reportAd(ad.id, reasonController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ad reported successfully')),
                );
              }
            },
            child: Text('Report'),
          ),
        ],
      ),
    );
  }
}

PHASE 12: Fix Authentication Screens
Step 12.1: Fix LoginScreen
dart// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or Title
              Text(
                'Welcome to ListyNest',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 48),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Login Button
              authProvider.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
              SizedBox(height: 16),

              // Register Link
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: Text('Don\'t have an account? Register'),
              ),

              // Error Message
              if (authProvider.errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    authProvider.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await context.read<AuthProvider>().login(
              _emailController.text.trim(),
              _passwordController.text,
            );
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }
}
Step 12.2: Fix RegisterScreen
dart// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 48),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 48),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Register Button
                authProvider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: Text('Register'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                        ),
                      ),
                SizedBox(height: 16),

                // Login Link
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Already have an account? Login'),
                ),

                // Error Message
                if (authProvider.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await context.read<AuthProvider>().register(
              _emailController.text.trim(),
              _passwordController.text,
            );
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')),
        );
      }
    }
  }
}
