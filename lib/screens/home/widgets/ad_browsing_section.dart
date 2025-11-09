
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/ad_provider.dart';
import '../../../widgets/ad_card.dart';

class AdBrowsingSection extends StatelessWidget {
  const AdBrowsingSection({super.key});

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

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: adProvider.ads.length,
            itemBuilder: (context, index) {
              final ad = adProvider.ads[index];
              return AdCard(ad: ad);
            },
          ),
        );
      },
    );
  }
}
