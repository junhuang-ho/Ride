import 'package:flutter/material.dart';
import 'package:ride/app/driver/widgets/ride_button.dart';
import 'package:ride/app/driver/widgets/taxi_outlined_button.dart';
import 'package:ride/utils/ride_colors.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function()? onPressed;

  const ConfirmSheet({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: RideColors.cardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              spreadRadius: .5,
              offset: Offset(0.7, 0.7))
        ],
      ),
      height: 220,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Brand-Bold',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: TaxiOutlinedButton(
                    title: 'Back',
                    color: const Color(0xFFe2e2e2),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RideButton(
                    onPressed: onPressed,
                    color: (title == 'Go Online')
                        ? RideColors.colorGreen
                        : Colors.red,
                    title: 'Confirm',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
