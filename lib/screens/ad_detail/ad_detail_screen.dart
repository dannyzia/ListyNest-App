import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/ad.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/ad_provider.dart';

class AdDetailScreen extends StatelessWidget {
  final Ad ad;

  const AdDetailScreen({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final adProvider = context.read<AdProvider>();
    final favoriteProvider = context.read<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('Check out this ad: ${ad.title} - ${ad.currency ?? ''} ${ad.price}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.report),
            onPressed: () => _showReportDialog(context, adProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            if (ad.imageUrls.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: ad.imageUrls.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: ad.imageUrls[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    );
                  },
                ),
              )
            else
              Container(
                height: 300,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    ad.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    '${ad.currency ?? ''} ${ad.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  if (ad.location != null)
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          '${ad.location!.city}, ${ad.location!.state}, ${ad.location!.country}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),

                  // Category
                  if (ad.category != null)
                    Chip(
                      label: Text(ad.category!),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ad.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // Contact Buttons
                  if (ad.contactEmail != null || ad.contactPhone != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Seller',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (ad.contactEmail != null)
                          ElevatedButton.icon(
                            onPressed: () => _launchEmail(ad.contactEmail!),
                            icon: const Icon(Icons.email),
                            label: const Text('Email Seller'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        if (ad.contactPhone != null) ...[
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _launchPhone(ad.contactPhone!),
                            icon: const Icon(Icons.phone),
                            label: const Text('Call Seller'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: authProvider.isLoggedIn
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    favoriteProvider.toggleFavorite(ad.id, authProvider.user!.uid);
                  },
                  icon: Consumer<FavoriteProvider>(
                    builder: (context, provider, child) => Icon(
                      provider.isFavorite(ad.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  ),
                  label: const Text('Add to Favorites'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Inquiry about ${ad.title}',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _showReportDialog(BuildContext context, AdProvider adProvider) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Ad'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            hintText: 'Enter reason for reporting',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.isNotEmpty) {
                await adProvider.reportAd(ad.id, reasonController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ad reported successfully')),
                );
              }
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }
}
