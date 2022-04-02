import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ride/utils/ride_colors.dart';

class PendingTransaction extends StatelessWidget {
  const PendingTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SpinKitPouringHourGlass(color: RideColors.primaryColor),
        SizedBox(height: 15),
        Text(
          'Pending Blockend Transaction...',
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Please don\'t leave the app...',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
