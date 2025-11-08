import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotosStep extends StatefulWidget {
  final Function(List<XFile>) onImagesSelected;

  const PhotosStep({Key? key, required this.onImagesSelected}) : super(key: key);

  @override
  _PhotosStepState createState() => _PhotosStepState();
}

class _PhotosStepState extends State<PhotosStep> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  Future<void> _pickImages() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images = pickedImages;
      });
      widget.onImagesSelected(_images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImages,
          child: Text('Upload Photos'),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return Image.file(File(_images[index].path));
          },
        ),
      ],
    );
  }
}
