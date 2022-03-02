import 'package:flutter/material.dart';

class TaxiOutlinedButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final Color color;

  const TaxiOutlinedButton({
    Key? key,
    required this.title,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        foregroundColor: MaterialStateProperty.all<Color>(color),
        side: MaterialStateProperty.all<BorderSide>(BorderSide(color: color)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: 50.0,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              fontFamily: 'Brand-Bold',
              color: Color(0xFF383635),
            ),
          ),
        ),
      ),
    );
  }
}
