import 'package:go_router/go_router.dart';
import 'package:listynest/screens/home/home_screen.dart';
import 'package:listynest/screens/listings/listings_screen.dart';
import 'package:listynest/screens/create_ad/create_ad_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/listings',
      builder: (context, state) => ListingsScreen(),
    ),
    GoRoute(
      path: '/create_ad',
      builder: (context, state) => CreateAdScreen(),
    ),
  ],
);
