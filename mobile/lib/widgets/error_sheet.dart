import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/widgets/common_sheet.dart';

class ErrorSheet extends HookConsumerWidget {
  const ErrorSheet({
    Key? key,
    required this.errorSheetHeight,
    required this.errorMessage,
  }) : super(key: key);

  final double errorSheetHeight;
  final String errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonSheet(
      sheetHeight: errorSheetHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            const Text(
              'Oops, something goes wrong!!!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 15),
            Text(errorMessage),
          ],
        ),
      ),
    );
  }
}
