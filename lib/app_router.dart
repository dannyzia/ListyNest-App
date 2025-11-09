import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listynest/screens/ad_details_screen.dart';
import 'package:listynest/screens/create_ad/create_ad_screen.dart';
import 'package:listynest/screens/main_screen.dart';
import 'package:listynest/screens/user/favorites_screen.dart';
import 'package:listynest/screens/user/my_account_screen.dart';
import 'package:listynest/screens/user/my_ads_screen.dart';
import 'package:listynest/screens/user/my_bids_screen.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const MainScreen(),
      ),
      GoRoute(
        path: '/ad/new',
        builder: (BuildContext context, GoRouterState state) =>
            const CreateAdScreen(),
      ),
      GoRoute(
        path: '/ad/:id',
        builder: (BuildContext context, GoRouterState state) =>
            AdDetailsScreen(adId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/my-account',
        builder: (BuildContext context, GoRouterState state) =>
            const MyAccountScreen(),
      ),
      GoRoute(
        path: '/my-ads',
        builder: (BuildContext context, GoRouterState state) =>
            const MyAdsScreen(),
      ),
      GoRoute(
        path: '/my-favorites',
        builder: (BuildContext context, GoRouterState state) =>
            const FavoritesScreen(),
      ),
      GoRoute(
        path: '/my-bids',
        builder: (BuildContext context, GoRouterState state) =>
            const MyBidsScreen(),
      ),
    ],
  );
}
