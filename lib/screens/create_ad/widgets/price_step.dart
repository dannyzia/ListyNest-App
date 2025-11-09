import 'package:flutter/material.dart';

class PriceStep extends StatelessWidget {
  final TextEditingController priceController;

  const PriceStep({super.key, required this.priceController});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'Price',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a price';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
