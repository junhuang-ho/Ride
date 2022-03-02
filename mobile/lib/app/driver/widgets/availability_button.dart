import 'package:flutter/material.dart';

class AvailabilityButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function()? onPressed;

  const AvailabilityButton({
    Key? key,
    required this.title,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
      child: SizedBox(
        height: 50,
        width: 200,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Brand-Bold',
            ),
          ),
        ),
      ),
    );
  }
}
