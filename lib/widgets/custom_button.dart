import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({super.key, required this.text, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: AppTheme.lightTheme.elevatedButtonTheme.style,
      child: isLoading
          ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          : Text(text),
    );
  }
}
