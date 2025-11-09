import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:listynest/models/ad.dart';
import 'package:listynest/providers/ad_provider.dart';
import 'package:listynest/providers/auth_provider.dart';
import 'package:listynest/screens/home/home_screen.dart';

import 'widgets/details_step.dart';
import 'widgets/photos_step.dart';
import 'widgets/price_step.dart';

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({super.key});

  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _price = 0.0;
  List<XFile> _images = [];

  void _publishAd() async {
    if (!_formKey.currentState!.validate()) return;

    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final ad = Ad(
      id: '',
      title: _title,
      description: _description,
      price: _price,
      userId: authProvider.user!.uid,
      imageUrls: [],
    );

    await adProvider.createAd(ad, _images);

    if (adProvider.errorMessage == null && mounted) {
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final adProvider = Provider.of<AdProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Listing'),
      ),
      body: adProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DetailsStep(
                      formKey: _formKey,
                      onChanged: (title, description) {
                        setState(() {
                          _title = title;
                          _description = description;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    PhotosStep(
                      onImagesSelected: (images) {
                        setState(() {
                          _images = images;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    PriceStep(
                      onChanged: (price) {
                        setState(() {
                          _price = price;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _publishAd,
                      child: const Text('Publish'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
