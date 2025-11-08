import 'package:flutter/material.dart';
import 'widgets/ad_details.dart';
import 'widgets/seller_info.dart';

class AdDetailScreen extends StatelessWidget {
  const AdDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ad Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdDetails(),
            SellerInfo(),
          ],
        ),
      ),
    );
  }
}
