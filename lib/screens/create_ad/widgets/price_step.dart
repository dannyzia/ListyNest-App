import 'package:flutter/material.dart';

class PriceStep extends StatelessWidget {
  final Function(double) onChanged;

  const PriceStep({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Price'),
      keyboardType: TextInputType.number,
      onChanged: (value) => onChanged(double.tryParse(value) ?? 0.0),
    );
  }
}
