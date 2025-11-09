import 'package:flutter/material.dart';

class ImageUploader extends StatelessWidget {
  const ImageUploader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Center(
        child: Text('Image Uploader'),
      ),
    );
  }
}
