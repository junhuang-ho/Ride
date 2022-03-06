import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/admin/admin.view.dart';
import 'package:ride/app/driver/driver.view.dart';
import 'package:ride/app/driver/register.driver.view.dart';
import 'package:ride/app/driver/trip/driver.trip.view.dart';
import 'package:ride/app/passenger/home/passenger.home.view.dart';
import 'package:ride/app/passenger/search/passenger.search.view.dart';
import 'package:ride/app/qrcode.reader.view.dart';
import 'package:ride/app/ride/ride.view.dart';
import 'package:ride/app/wallet/deposit/deposit.wallet.view.dart';
import 'package:ride/app/wallet/send/send.wallet.view.dart';
import 'package:ride/app/wallet/setup/create.wallet.view.dart';
import 'package:ride/app/wallet/setup/import.wallet.view.dart';
import 'package:ride/app/wallet/wallet.view.dart';
import 'package:ride/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ride/app/app.view.dart';
import 'package:ride/services/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    name: 'Ride',
    options: const FirebaseOptions(
      apiKey: kMapKey,
      appId: '1:753391378700:android:62dbb98f5deff97be5a929',
      messagingSenderId: '753391378700',
      projectId: 'ride-e955b',
    ),
  );

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
          GoRoute(
            path: 'qrcode_reader',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: QRCodeReaderView(
                onScanned: state.extra as OnScanned,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const AdminView(),
        ),
      ),
      GoRoute(
        path: '/driver',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const DriverView(),
        ),
        routes: [
          GoRoute(
            path: 'register',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const RegisterDriverView(),
            ),
          ),
          GoRoute(
            path: 'trip',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const DriverTripView(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/passenger',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: PassengerHomeView(),
        ),
        routes: [
          GoRoute(
            path: 'wallet',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const WalletView(),
            ),
            routes: [
              GoRoute(
                path: 'send',
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: const SendWalletView(),
                ),
              ),
              GoRoute(
                path: 'deposit',
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: const DepositWalletView(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'search',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const PassengerSearchView(),
            ),
          ),
          GoRoute(
            path: 'ride',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const RideView(),
            ),
          ),
        ],
      ),
    ],
  );
}
