import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/screens/ad_details/ad_details_screen.dart';
import 'package:listynest/screens/auth/auth_screen.dart';
import 'package:listynest/screens/create_ad/create_ad_screen.dart';
import 'package:listynest/screens/favorites/favorites_screen.dart';
import 'package:listynest/screens/listings/listings_screen.dart';
import 'package:listynest/screens/my_ads/my_ads_screen.dart';
import 'package:listynest/screens/user_profile/user_profile_screen.dart';
import 'package:listynest/services/auth_service.dart';

class App extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        final router = GoRouter(
          initialLocation: '/',
          redirect: (context, state) {
            final loggedIn = snapshot.hasData;
            final loggingIn = state.matchedLocation == '/auth';

            if (!loggedIn && !loggingIn) {
              return '/auth';
            }

            if (loggedIn && loggingIn) {
              return '/listings';
            }

            return null;
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => ListingsScreen(),
            ),
            GoRoute(
              path: '/auth',
              builder: (context, state) => AuthScreen(),
            ),
            GoRoute(
              path: '/listings',
              builder: (context, state) => ListingsScreen(),
            ),
            GoRoute(
              path: '/create_ad',
              builder: (context, state) => CreateAdScreen(),
            ),
            GoRoute(
              path: '/my_ads',
              builder: (context, state) => MyAdsScreen(),
            ),
            GoRoute(
              path: '/favorites',
              builder: (context, state) => FavoritesScreen(),
            ),
            GoRoute(
              path: '/ad/:adId',
              builder: (context, state) => AdDetailsScreen(
                adId: state.pathParameters['adId']!,
              ),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => UserProfileScreen(),
            ),
          ],
        );

        return MaterialApp.router(
          routerConfig: router,
          title: 'ListyNest',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        );
      },
    );
  }
}
