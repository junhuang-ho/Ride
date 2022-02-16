import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:ride/app/account/account.vm.dart';
import 'package:ride/utils/eth_amount_formatter.dart';
import 'package:ride/widgets/empty_content.dart';

class MainMenu extends HookConsumerWidget {
  const MainMenu({
    Key? key,
    this.onReset,
    this.onRevealKey,
  }) : super(key: key);

  final GestureTapCallback? onReset;
  final GestureTapCallback? onRevealKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);

    return Container(
      width: 300,
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            Container(
              height: 250,
              child: DrawerHeader(
                child: account.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (errorMsg) => EmptyContent(
                    title: 'Something went wrong',
                    message: errorMsg ?? '',
                  ),
                  data: (accountData) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        child: SvgPicture.string(
                          Jdenticon.toSvg(accountData.publicKey),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        accountData.publicKey,
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'Brand-Bold'),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${EthAmountFormatter(accountData.balance!.getInWei).format()} MATIC',
                      ),
                      if (accountData.isOwner)
                        ListTile(
                          title: const Text('Admin Panel'),
                          subtitle: const Text('Ride Administration'),
                          trailing: const Icon(Icons.admin_panel_settings),
                          onTap: () => context.go('/home/admin'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xffe2e2e2), thickness: 1),
            ListTile(
              title: const Text('Private key'),
              subtitle: const Text('Reveal your private key'),
              trailing: const Icon(Icons.vpn_key),
              onTap: onRevealKey,
            ),
            ListTile(
              title: const Text('Reset wallet'),
              subtitle: const Text('Wipe all wallet data'),
              trailing: const Icon(
                Icons.warning,
                color: Colors.orange,
              ),
              onTap: onReset,
            ),
          ],
        ),
      ),
    );
  }
}
