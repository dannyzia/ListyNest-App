import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({super.key});

  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Ad'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomInputField(labelText: 'Title', controller: _titleController),
              SizedBox(height: 16.0),
              CustomInputField(labelText: 'Description', controller: _descriptionController),
              SizedBox(height: 16.0),
              CustomInputField(labelText: 'Price', controller: _priceController, keyboardType: TextInputType.number),
              SizedBox(height: 16.0),
              // Placeholder for image picker
              Text('Image Picker Placeholder'),
              SizedBox(height: 16.0),
              // Placeholder for category picker
              Text('Category Picker Placeholder'),
              SizedBox(height: 16.0),
              CustomButton(text: 'Create Ad', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
