import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listynest/screens/create_ad/widgets/details_step.dart';
import 'package:listynest/screens/create_ad/widgets/photos_step.dart';
import 'package:listynest/screens/create_ad/widgets/price_step.dart';
import 'package:listynest/services/ad_service.dart';

class CreateAdScreen extends StatefulWidget {
  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  List<XFile> _images = [];
  bool _isLoading = false;
  final AdService _adService = AdService();

  void _publishAd() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _adService.uploadAd(
        _titleController.text,
        _descriptionController.text,
        double.parse(_priceController.text),
        _images,
      );

      setState(() {
        _isLoading = false;
      });

      context.go('/listings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Listing'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stepper(
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isLastStep = _currentStep == 2;
                return Row(
                  children: <Widget>[
                    if (isLastStep)
                      ElevatedButton(
                        onPressed: _publishAd,
                        child: const Text('PUBLISH'),
                      )
                    else
                      TextButton(
                        onPressed: details.onStepContinue,
                        child: const Text('NEXT'),
                      ),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('BACK'),
                    ),
                  ],
                );
              },
              currentStep: _currentStep,
              onStepContinue: () {
                final isLastStep = _currentStep == 2;
                if (!isLastStep) {
                  setState(() {
                    _currentStep += 1;
                  });
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              steps: [
                Step(
                  title: Text('Details'),
                  content: DetailsStep(
                    formKey: _formKey,
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                  ),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: Text('Photos'),
                  content: PhotosStep(
                    onImagesSelected: (images) {
                      _images = images;
                    },
                  ),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: Text('Price'),
                  content: PriceStep(
                    priceController: _priceController,
                  ),
                  isActive: _currentStep >= 2,
                ),
              ],
            ),
    );
  }
}
