import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/ad_provider.dart';
import 'package:listynest/providers/auth_provider.dart';
import 'package:listynest/widgets/loading_widget.dart';
import 'package:listynest/widgets/empty_state_widget.dart';
import 'package:intl/intl.dart';

class MyBidsScreen extends StatefulWidget {
  const MyBidsScreen({super.key});

  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      Provider.of<AdProvider>(context, listen: false).fetchMyBids();
    }
  }

  @override
  Widget build(BuildContext context) {
    final adProvider = Provider.of<AdProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bids'),
      ),
      body: authProvider.user == null
          ? const Center(
              child: Text('You need to be logged in to see your bids.'),
            )
          : _buildBidsList(adProvider),
    );
  }

  Widget _buildBidsList(AdProvider adProvider) {
    switch (adProvider.state) {
      case AdState.loading:
        return const LoadingWidget();
      case AdState.loaded:
        if (adProvider.bids.isEmpty) {
          return const EmptyStateWidget(
            message: 'You have not placed any bids yet.',
          );
        }
        return ListView.builder(
          itemCount: adProvider.bids.length,
          itemBuilder: (context, index) {
            final bid = adProvider.bids[index];
            return ListTile(
              title: Text('Bid on ad: ${bid.ad}'),
              subtitle: Text(
                  'Amount: ${NumberFormat.simpleCurrency().format(bid.amount)}\nPlaced on: ${DateFormat.yMMMd().format(bid.createdAt)}'),
              onTap: () {
                context.go('/ad/${bid.ad}');
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
