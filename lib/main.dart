// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/ad_provider.dart';
import 'providers/search_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/category_provider.dart';
import 'providers/blog_provider.dart';
import 'providers/notification_provider.dart';
import 'services/blog_service.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/ad_service.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'services/upload_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for notifications
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core services
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<ApiService>(create: (context) => ApiService(context.read<StorageService>())),

  // App services/providers
  Provider<AdService>(create: (context) => AdService(context.read<ApiService>())),
  Provider<AuthService>(create: (context) => AuthService(context.read<ApiService>(), context.read<StorageService>())),
  Provider<BlogService>(create: (context) => BlogService(context.read<ApiService>())),
        Provider<UploadService>(create: (context) => UploadService(context.read<ApiService>())),
  ChangeNotifierProvider(create: (context) => BlogProvider(context.read<BlogService>())),
  ChangeNotifierProvider(create: (context) => AuthProvider(context.read<AuthService>(), context.read<StorageService>())),
        ChangeNotifierProxyProvider<AdService, AdProvider>(
          create: (context) => AdProvider(adService: context.read<AdService>(), uploadService: context.read<UploadService>()),
          update: (context, adService, adProvider) => AdProvider(adService: adService, uploadService: context.read<UploadService>()),
        ),
        ChangeNotifierProxyProvider<AdService, SearchProvider>(
          create: (context) => SearchProvider(adService: context.read<AdService>()),
          update: (context, adService, searchProvider) => SearchProvider(adService: adService),
        ),
  ChangeNotifierProvider(create: (context) => FavoriteProvider(adService: context.read<AdService>())),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
  ChangeNotifierProvider(create: (context) => NotificationProvider(context.read<StorageService>())),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'ListyNest',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: const Color(0xFF4F46E5),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF4F46E5),
            secondary: Color(0xFF9333EA),
          ),
          scaffoldBackgroundColor: const Color(0xFFF9FAFB),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: IconThemeData(color: Color(0xFF111827)),
            titleTextStyle: TextStyle(
              color: Color(0xFF111827),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
            home: authProvider.isLoading
                ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                : (authProvider.isAuthenticated ? const HomeScreen() : const AuthScreen()),
          );
        },
      ),
    );
  }
}
