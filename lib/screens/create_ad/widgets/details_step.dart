import 'package:flutter/material.dart';

class DetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(String, String) onChanged;

  const DetailsStep({super.key, required this.formKey, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: (value) => onChanged(value, ''),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            onChanged: (value) => onChanged('', value),
          ),
        ],
      ),
    );
  }
}
