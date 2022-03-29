import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:ride/app/wallet/widgets/address_copy_button.dart';
import 'package:ride/utils/eth_amount_formatter.dart';
import 'package:ride/utils/ride_colors.dart';

class RideDetailsContent extends StatelessWidget {
  const RideDetailsContent({
    Key? key,
    this.userId,
    required this.distanceText,
    required this.durationText,
    required this.fare,
    required this.pickupAddress,
    required this.destAddress,
    this.showPickupAndDest = true,
  }) : super(key: key);

  final String? userId;
  final String distanceText;
  final String durationText;
  final BigInt fare;
  final String pickupAddress;
  final String destAddress;
  final bool showPickupAndDest;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 2),
            const Text(
              'Ride Ticket',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 2),
            const Divider(color: RideColors.primaryColor),
            const SizedBox(height: 2),
            if (userId != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      child: SvgPicture.string(
                        Jdenticon.toSvg(userId!),
                      ),
                      radius: 20,
                    ),
                  ),
                  AddressCopyButton(publicKey: userId!),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Distance',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      distanceText,
                      style: const TextStyle(
                        fontSize: 20,
                        color: RideColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Duration',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      durationText,
                      style: const TextStyle(
                        fontSize: 20,
                        color: RideColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Fare',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '\$${EthAmountFormatter(fare).formatFiat()}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: RideColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: showPickupAndDest ? 10 : 0),
            if (showPickupAndDest)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pickup',
                          style: TextStyle(color: RideColors.lightGrayColor),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          pickupAddress,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Destination',
                          style: TextStyle(color: RideColors.lightGrayColor),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          destAddress,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
