import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/ad.dart';
import '../../../providers/ad_provider.dart';
import '../../ad_detail/ad_detail_screen.dart';

class TodaysTopPicksSection extends StatelessWidget {
  const TodaysTopPicksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdProvider>(
      builder: (context, adProvider, child) {
        if (adProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (adProvider.errorMessage != null) {
          return Center(child: Text(adProvider.errorMessage!));
        }

        if (adProvider.ads.isEmpty) {
          return const Center(child: Text('No ads available.'));
        }

        final topPicks = (adProvider.ads..shuffle()).take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Top Picks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topPicks.length,
                itemBuilder: (context, index) {
                  final ad = topPicks[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdDetailScreen(ad: ad),
                        ),
                      );
                    },
                    child: AdCard(ad: ad),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class AdCard extends StatelessWidget {
  final Ad ad;

  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ad.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  ad.imageUrls.first,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ad.currency} ${ad.price}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
