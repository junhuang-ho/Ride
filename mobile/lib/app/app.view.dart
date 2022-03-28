import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/admin/admin.view.dart';
import 'package:ride/app/auth/auth.view.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/driver/driver.view.dart';
import 'package:ride/app/passenger/home/passenger.home.view.dart';
import 'package:ride/models/account.dart';
import 'package:ride/widgets/empty_content.dart';

class AppView extends HookConsumerWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return auth.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (errorMsg) => Scaffold(
        body: EmptyContent(
          title: 'Something went wrong',
          message: errorMsg ?? 'Can\'t load data right now.',
        ),
      ),
      authenticated: (accountData) {
        if (accountData.accountType == AccountType.admin) {
          return const AdminView();
        } else if (accountData.accountType == AccountType.driver) {
          return const DriverView();
        } else {
          return PassengerHomeView();
        }
      },
      unAuthenticated: () => const AuthView(),
    );
  }
}
