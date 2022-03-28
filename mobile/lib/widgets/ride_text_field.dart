import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ride/utils/ride_colors.dart';

class RideTextField extends StatelessWidget {
  const RideTextField({
    Key? key,
    this.initialValue = '',
    required this.validator,
    required this.name,
    required this.label,
    this.textEditingController,
    this.readOnly = false,
    this.focusNode,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final String name;
  final String label;
  final TextEditingController? textEditingController;
  final bool readOnly;
  final String initialValue;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: FormBuilderTextField(
        name: name,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: textEditingController,
        readOnly: readOnly,
        // focusNode: focusNode,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: RideColors.primaryColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: RideColors.errorColor)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          label: Text(label),
          helperText: '',
          hintText: '',
          hintStyle: helperStyle,
        ),
        initialValue: textEditingController == null ? initialValue : null,
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }
}
