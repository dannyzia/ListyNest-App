import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/screens/main/main_screen.dart';
import 'package:listynest/screens/home/home_screen.dart';
import 'package:listynest/screens/search/search_screen.dart';
import 'package:listynest/screens/profile/profile_screen.dart';
import 'package:listynest/screens/profile/edit_profile_screen.dart';
import 'package:listynest/screens/menu/menu_screen.dart';
import 'package:listynest/screens/auth/login_screen.dart';
import 'package:listynest/screens/auth/register_screen.dart';
import 'package:listynest/screens/ad_detail/ad_detail_screen.dart';
import 'package:listynest/screens/post_ad/post_ad_screen.dart';
import 'package:listynest/screens/saved_searches_screen.dart';
import 'package:listynest/screens/favorites/favorites_screen.dart';
import 'package:listynest/screens/bids/my_bids_screen.dart';
import 'package:listynest/providers/auth_provider.dart';

class AppRouter {
  final AuthProvider authProvider;
  final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  AppRouter({required this.authProvider}) {
    authProvider.checkAuth();
  }

  GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/',
        refreshListenable: authProvider,
        redirect: (BuildContext context, GoRouterState state) {
          final bool loggedIn = authProvider.isLoggedIn;
          final bool loggingIn = state.matchedLocation == '/login';
          final bool registering = state.matchedLocation == '/register';

          if (!loggedIn) {
            return loggingIn || registering ? null : '/login';
          }

          if (loggingIn || registering) {
            return '/';
          }

          return null;
        },
        routes: [
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) {
              return MainScreen(child: child);
            },
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ]
              ),
              GoRoute(
                path: '/menu',
                builder: (context, state) => const MenuScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/ad/:id',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) =>
                AdDetailScreen(adId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/post-ad',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const PostAdScreen(),
          ),
          GoRoute(
            path: '/saved-searches',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const SavedSearchesScreen(),
          ),
          GoRoute(
            path: '/favorites',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/my-bids',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const MyBidsScreen(),
          ),
          GoRoute(
            path: '/login',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/register',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const RegisterScreen(),
          ),
        ],
      );
}
