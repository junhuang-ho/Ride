import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride/utils/ride_colors.dart';

class AddressCopyButton extends StatelessWidget {
  const AddressCopyButton({
    Key? key,
    required this.publicKey,
  }) : super(key: key);

  final String publicKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 30.0,
      decoration: const BoxDecoration(
        color: RideColors.grey,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: publicKey));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Public address copied to clipboard'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 75.0,
              child: Text(
                publicKey,
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 45.0,
              child: Text(
                publicKey.substring(publicKey.length - 4),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
