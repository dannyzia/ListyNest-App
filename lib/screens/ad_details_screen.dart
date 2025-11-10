import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:listynest/providers/ad_provider.dart';

class AdDetailsScreen extends StatefulWidget {
  final String adId;

  const AdDetailsScreen({super.key, required this.adId});

  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch ad details when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdProvider>(context, listen: false).fetchAdById(widget.adId);
    });
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
          if (adProvider.isLoading && adProvider.selectedAd == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (adProvider.errorMessage != null) {
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
                  Text(
                    'Price: \$${ad.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
