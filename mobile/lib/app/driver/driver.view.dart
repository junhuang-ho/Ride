import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/home/driver.home.view.dart';
import 'package:ride/app/driver/profile/driver.profile.view.dart';
import 'package:ride/app/wallet/wallet.view.dart';

class DriverView extends HookConsumerWidget {
  const DriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final selectedIndex = useState<int>(0);

    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: const <Widget>[
          DriverHomeView(),
          WalletView(),
          DriverProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex.value,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          selectedIndex.value = index;
          tabController.index = selectedIndex.value;
        },
      ),
    );
  }
}
