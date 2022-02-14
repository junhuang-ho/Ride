import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.view.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/home/home.view.dart';
import 'package:ride/widgets/empty_content.dart';

class AppView extends HookConsumerWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return auth.map(
      loading: (_) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_) => const Scaffold(
        body: EmptyContent(
          title: 'Something went wrong',
          message: 'Can\'t load data right now.',
        ),
      ),
      authenticated: (_) => const HomeView(),
      unAuthenticated: (_) => const AuthView(),
    );
  }
}
