import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listynest/models/ad.dart';
import 'package:listynest/providers/ad_provider.dart';
import 'package:listynest/screens/create_ad/widgets/details_step.dart';
import 'package:listynest/screens/create_ad/widgets/photos_step.dart';
import 'package:listynest/screens/create_ad/widgets/price_step.dart';
import 'package:provider/provider.dart';

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({super.key});

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

  void _publishAd() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final ad = Ad(
        id: ' ',
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        images: _images.map((xfile) => AdImage(url: xfile.path)).toList(),
        userId: ' ',
        category: ' ',
        location: ' ',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        expiresAt: DateTime.now(),
      );

      try {
        await Provider.of<AdProvider>(context, listen: false).createAd(ad);

        if (mounted) {
          context.go('/listings');
        }
      } catch (e) {
        // Handle error
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Listing'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              controlsBuilder: (BuildContext context, StepperControls controls) {
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
                        onPressed: controls.onStepContinue,
                        child: const Text('NEXT'),
                      ),
                    TextButton(
                      onPressed: controls.onStepCancel,
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
                  title: const Text('Details'),
                  content: DetailsStep(
                    formKey: _formKey,
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                  ),
                  isActive: _currentStep >= 0,
                ),
                Step(
                  title: const Text('Photos'),
                  content: PhotosStep(
                    onImagesSelected: (images) {
                      _images = images;
                    },
                  ),
                  isActive: _currentStep >= 1,
                ),
                Step(
                  title: const Text('Price'),
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
