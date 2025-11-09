import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/screens/ad_details/ad_details_screen.dart';
import 'package:listynest/screens/auth/auth_screen.dart';
import 'package:listynest/screens/create_ad/create_ad_screen.dart';
import 'package:listynest/screens/favorites/favorites_screen.dart';
import 'package:listynest/screens/listings/listings_screen.dart';
import 'package:listynest/screens/my_ads/my_ads_screen.dart';
import 'package:listynest/screens/user/chat_screen.dart';
import 'package:listynest/screens/user/conversations_screen.dart';
import 'package:listynest/screens/user_profile/user_profile_screen.dart';
import 'package:listynest/services/auth_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      refreshListenable: GoRouterRefreshStream(_authService.authStateChanges),
      initialLocation: '/',
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = _authService.currentUser != null;
        final bool loggingIn = state.matchedLocation == '/auth';

        if (!loggedIn) {
          return loggingIn ? null : '/auth';
        }

        if (loggingIn) {
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
        GoRoute(
          path: '/conversations',
          builder: (context, state) => ConversationsScreen(),
        ),
        GoRoute(
          path: '/chat/:conversationId',
          builder: (context, state) => ChatScreen(
            conversationId: state.pathParameters['conversationId']!,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'ListyNest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
