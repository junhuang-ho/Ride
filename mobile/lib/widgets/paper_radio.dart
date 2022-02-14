import 'package:flutter/material.dart';

typedef OnRadioChanged = void Function(
  dynamic value,
);

class PaperRadio extends StatelessWidget {
  const PaperRadio(
    this.title, {
    Key? key,
    this.value,
    this.groupValue,
    this.onChanged,
  }) : super(key: key);

  final dynamic value;
  final String title;
  final dynamic groupValue;
  final OnRadioChanged? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(title),
      ],
    );
  }
}
