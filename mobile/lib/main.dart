import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ride/app/app.view.dart';
import 'package:ride/app/home/home.view.dart';
import 'package:ride/app/wallet/import.wallet.view.dart';
import 'package:ride/app/wallet/create.wallet.view.dart';
import 'package:ride/services/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        repositoryProvider.overrideWithValue(Repository(sharedPreferences)),
      ],
      child: RideApp(),
    ),
  );
}

class RideApp extends ConsumerWidget {
  RideApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Ride App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellow.shade800,
        primarySwatch: Colors.yellow,
        fontFamily: 'Brand-Bold',
      ),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const AppView(),
        ),
        routes: [
          GoRoute(
            path: 'create-wallet',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const CreateWalletView(),
            ),
          ),
          GoRoute(
            path: 'import-wallet',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const ImportWalletView(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const HomeView(),
        ),
      ),
    ],
  );
}
