import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/ad_provider.dart';
import 'package:listynest/models/ad.dart';

class AdDetailsScreen extends StatefulWidget {
  final String adId;

  const AdDetailsScreen({super.key, required this.adId});

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  final _bidAmountController = TextEditingController();
  bool _isBidding = false;

  @override
  void initState() {
    super.initState();
    // Fetch ad details when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdProvider>(context, listen: false).fetchAdById(widget.adId);
    });
  }

  @override
  void dispose() {
    _bidAmountController.dispose();
    super.dispose();
  }

  void _placeBid(BuildContext context) async {
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final amount = double.tryParse(_bidAmountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid bid amount.')),
      );
      return;
    }

    setState(() {
      _isBidding = true;
    });

    try {
      await adProvider.placeBid(widget.adId, amount);
      _bidAmountController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bid placed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place bid: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isBidding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AdProvider>(
          builder: (context, adProvider, child) {
            final ad = adProvider.selectedAd;
            return Text(ad?.title ?? 'Ad Details');
          },
        ),
      ),
      body: Consumer<AdProvider>(
        builder: (context, adProvider, child) {
          if (adProvider.state == AdState.loading && adProvider.selectedAd == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (adProvider.state == AdState.error) {
            return Center(child: Text('Error: ${adProvider.errorMessage}'));
          }

          final ad = adProvider.selectedAd;

          if (ad == null) {
            return const Center(child: Text('Ad not found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8.0),
                  // Placeholder for image carousel
                  Container(
                    height: 200,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Text('Image Carousel'),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    ad.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  if (ad.isAuction)
                    _buildAuctionDetails(context, ad)
                  else
                    Text(
                      'Price: \$${ad.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  const SizedBox(height: 24.0),
                  // Seller information
                  const Text(
                    'Seller Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('John Doe'), // Replace with actual seller name
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuctionDetails(BuildContext context, Ad ad) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Starting Price: \$${ad.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Highest Bid: \$${ad.highestBid?.toStringAsFixed(2) ?? 'N/A'}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.green),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Auction Ends: ${ad.auctionEndDate?.toLocal().toString() ?? 'N/A'}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _bidAmountController,
                decoration: const InputDecoration(
                  labelText: 'Your Bid',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 8.0),
            _isBidding
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _placeBid(context),
                    child: const Text('Place Bid'),
                  ),
          ],
        ),
      ],
    );
  }
}
