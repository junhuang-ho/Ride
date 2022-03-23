import 'package:flutter/material.dart';

class SheetHandle extends StatelessWidget {
  const SheetHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 5.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey,
      ),
    );
  }
}
