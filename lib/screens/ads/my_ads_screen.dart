import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/ad_provider.dart';
import 'package:listynest/providers/auth_provider.dart';
import 'package:listynest/widgets/ad_list_item.dart';
import 'package:listynest/widgets/loading_widget.dart';
import 'package:listynest/widgets/empty_state_widget.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      Provider.of<AdProvider>(context, listen: false)
          .fetchAdsByUser(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adProvider = Provider.of<AdProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ads'),
      ),
      body: authProvider.user == null
          ? const Center(
              child: Text('You need to be logged in to see your ads.'),
            )
          : _buildAdsList(adProvider),
    );
  }

  Widget _buildAdsList(AdProvider adProvider) {
    switch (adProvider.state) {
      case AdState.loading:
        return const LoadingWidget();
      case AdState.loaded:
        if (adProvider.ads.isEmpty) {
          return const EmptyStateWidget(
            message: 'You have not posted any ads yet.',
          );
        }
        return ListView.builder(
          itemCount: adProvider.ads.length,
          itemBuilder: (context, index) {
            final ad = adProvider.ads[index];
            return AdListItem(
              ad: ad,
              onTap: () {
                context.go('/ad/${ad.id}');
              },
            );
          },
        );
      case AdState.error:
        return Center(
          child: Text(adProvider.errorMessage ?? 'An unknown error occurred.'),
        );
      case AdState.initial:
      default:
        return Container();
    }
  }
}
