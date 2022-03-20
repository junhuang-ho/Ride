import 'package:flutter/material.dart';

class WalletAppBar extends StatelessWidget with PreferredSizeWidget {
  const WalletAppBar({
    Key? key,
    required this.appBarTitle,
    this.actionWidgets = const [],
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  final String appBarTitle;
  final List<Widget> actionWidgets;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: automaticallyImplyLeading ? null : const SizedBox(width: 20),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(appBarTitle),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.circle, color: Colors.green, size: 10.0),
              SizedBox(width: 5.0),
              Text(
                'Mumbai Testnet',
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          )
        ],
      ),
      actions: actionWidgets,
    );
  }
}
