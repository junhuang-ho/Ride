import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/widgets/common_sheet.dart';

class CancellingSheet extends HookConsumerWidget {
  const CancellingSheet({
    Key? key,
    required this.cancellingSheetHeight,
  }) : super(key: key);

  final double cancellingSheetHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonSheet(
      sheetHeight: cancellingSheetHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: const <Widget>[
            Text(
              'Cancelling....',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Brand-Bold',
              ),
            ),
            SizedBox(height: 15),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
