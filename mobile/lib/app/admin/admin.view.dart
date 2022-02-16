import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminView extends HookConsumerWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: const Center(
        child: Text('Welcome to Admin Panel!'),
      ),
    );
  }
}
