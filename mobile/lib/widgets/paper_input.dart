import 'package:flutter/material.dart';
import 'package:ride/utils/ride_colors.dart';

class PaperInput extends StatelessWidget {
  const PaperInput(
      {Key? key,
      required this.labelText,
      this.hintText,
      this.errorText,
      this.onChanged,
      this.controller,
      this.maxLines,
      this.obscureText = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final int? maxLines;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: RideColors.primaryColor)),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: RideColors.errorColor)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: RideColors.lightGrayColor)),
        border: const OutlineInputBorder(),
        errorStyle: const TextStyle(color: Colors.transparent),
        helperText: '',
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
      ),
    );
  }
}
