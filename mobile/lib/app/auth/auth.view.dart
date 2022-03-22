import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

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
            MaterialButton(
              height: 55,
              color: Colors.white,
              textColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () => context.go('/create-wallet'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Create new wallet'),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              height: 55,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () => context.go('/import-wallet'),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Import wallet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
