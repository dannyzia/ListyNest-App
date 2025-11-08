import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listynest/models/ad_model.dart';
import 'package:listynest/providers/ad_provider.dart';
import 'package:listynest/providers/auction_provider.dart';
import 'package:listynest/providers/auth_provider.dart';
import 'package:listynest/widgets/loading_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';

class AdDetailScreen extends StatefulWidget {
  final String adId;

  const AdDetailScreen({super.key, required this.adId});

  @override
  _AdDetailScreenState createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  final _bidController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Provider.of<AuctionProvider>(context, listen: false).listenToAd(widget.adId);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bidController.dispose();
    super.dispose();
  }

  void _shareAd(Ad ad) {
    final adUrl = 'https://listynest.com/ad/${ad.id}';
    Share.share('Check out this ad on ListyNest: ${ad.title}\n$adUrl');
  }

  void _showReportDialog(Ad ad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Ad'),
        content: const Text('Are you sure you want to report this ad?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Report'),
            onPressed: () {
              Provider.of<AdProvider>(context, listen: false).reportAd(ad.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ad reported successfully.')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showBidDialog(Ad ad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Place Bid'),
        content: TextField(
          controller: _bidController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter your bid'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Place Bid'),
            onPressed: () {
              final amount = double.tryParse(_bidController.text);
              final userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;
              if (amount != null) {
                Provider.of<AuctionProvider>(context, listen: false)
                    .placeBid(ad.id, amount, userId);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Detail'),
        actions: [
          Consumer<AuctionProvider>(
            builder: (context, auctionProvider, child) {
              final ad = auctionProvider.currentAd;
              if (ad != null) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareAd(ad),
                    ),
                    IconButton(
                      icon: const Icon(Icons.report),
                      onPressed: () => _showReportDialog(ad),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<AuctionProvider>(
        builder: (context, auctionProvider, child) {
          final ad = auctionProvider.currentAd;

          if (ad == null) {
            return const LoadingWidget();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  ad.images.isNotEmpty ? ad.images[0].url : 'https://via.placeholder.com/400x300',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8.0),
                      if (ad.auctionDetails == null)
                        Text(
                          '${ad.price} ${ad.currency}',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 16.0),
                      if (ad.auctionDetails != null)
                        _buildAuctionDetails(ad.auctionDetails!),
                      const SizedBox(height: 16.0),
                      Text('Description', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8.0),
                      Text(ad.description),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Consumer<AuctionProvider>(
        builder: (context, auctionProvider, child) {
          final ad = auctionProvider.currentAd;
          if (ad?.auctionDetails != null) {
            return FloatingActionButton(
              onPressed: () => _showBidDialog(ad!),
              child: const Icon(Icons.gavel),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAuctionDetails(AuctionDetails auction) {
    final remaining = auction.endTime.difference(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Auction Details', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8.0),
        Text('Starting Bid: ${auction.startingBid} ${'USD'}'),
        Text('Current Bid: ${auction.currentBid} ${'USD'}'),
        Text('Ends in: ${remaining.inDays}d ${remaining.inHours % 24}h ${remaining.inMinutes % 60}m ${remaining.inSeconds % 60}s'),
        const SizedBox(height: 16.0),
        Text('Bidding History', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8.0),
        ...auction.bids.map((bid) => Text('${bid.amount} by user ${bid.userId.substring(0, 5)}... at ${bid.timestamp}')),
      ],
    );
  }
}
