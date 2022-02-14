import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ride/app/wallet/setup.wallet.vm.dart';

class AuthView extends HookConsumerWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'RIDE',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'We need your credentials',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'But Nothing leaves this device',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
                child: const Text('Create new wallet'),
                onPressed: () {
                  ref.read(setupWalletProvider.notifier).generateMnemonic();
                  context.go('/create-wallet');
                }),
            Container(
              padding: const EdgeInsets.all(10),
              child: OutlinedButton(
                child: const Text('Import wallet'),
                onPressed: () => context.go('/import-wallet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
