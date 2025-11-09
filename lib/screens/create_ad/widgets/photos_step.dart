import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotosStep extends StatelessWidget {
  final Function(List<XFile>) onImagesSelected;

  const PhotosStep({super.key, required this.onImagesSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final picker = ImagePicker();
            final images = await picker.pickMultiImage();
            onImagesSelected(images);
          },
          child: const Text('Select Images'),
        ),
      ],
    );
  }
}
