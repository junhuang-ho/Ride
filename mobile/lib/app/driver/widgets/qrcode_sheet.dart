import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/widgets/sheet_handle.dart';

class QRCodeSheet extends HookConsumerWidget {
  const QRCodeSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            spreadRadius: .5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: <Widget>[
            const SheetHandle(),
            const SizedBox(height: 30),
            if (MediaQuery.of(context).orientation == Orientation.portrait ||
                kIsWeb)
              QrImage(
                data: auth.maybeWhen(
                  authenticated: (accountData) => accountData.publicKey,
                  orElse: () => '',
                ),
                size: 150.0,
                backgroundColor: Colors.white,
              ),
            const SizedBox(height: 15),
            const Text(
              'Passenger scan address to start trip',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
