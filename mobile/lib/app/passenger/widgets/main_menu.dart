import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/empty_content.dart';

class MainMenu extends HookConsumerWidget {
  const MainMenu({
    Key? key,
    this.onReset,
    this.onRevealMnemonic,
    this.onRevealKey,
  }) : super(key: key);

  final GestureTapCallback? onReset;
  final GestureTapCallback? onRevealMnemonic;
  final GestureTapCallback? onRevealKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 300,
      child: Drawer(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            const HeaderSection(),
            const SizedBox(height: 5),
            ListTile(
              title: const Text('Wallet', style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.monetization_on),
              onTap: () => context.go('/passenger/wallet'),
            ),
            ListTile(
              title:
                  const Text('Ride Holdings', style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.token),
              onTap: () => context.go('/passenger/holdings'),
            ),
            Consumer(
              builder: (context, ref, _) {
                final isMnemonicExist = ref.watch(authProvider.notifier
                    .select((authVM) => authVM.isMnemonicExist));
                if (isMnemonicExist) {
                  return ListTile(
                    title: const Text('Reveal Seed Phrase',
                        style: TextStyle(fontSize: 16)),
                    leading: const Icon(Icons.security),
                    onTap: onRevealMnemonic,
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            ListTile(
              title: const Text('Reveal private key',
                  style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.vpn_key),
              onTap: onRevealKey,
            ),
            ListTile(
              title: const Text('Log out', style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.logout),
              onTap: onReset,
            ),
            const Divider(height: 1, color: RideColors.grey, thickness: 1),
            ListTile(
              title:
                  const Text('Drive with Ride', style: TextStyle(fontSize: 16)),
              leading: const Icon(Icons.drive_eta),
              onTap: () => context.go('/apply_driver'),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends HookConsumerWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return SizedBox(
      height: 200,
      child: DrawerHeader(
        child: auth.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (errorMsg) => EmptyContent(
            title: 'Something went wrong',
            message: errorMsg ?? '',
          ),
          unAuthenticated: () => const EmptyContent(
            title: 'Sorry, you\'ve been logged out',
            message: '',
          ),
          authenticated: (accountData) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              CircleAvatar(
                radius: 25,
                backgroundColor: RideColors.primaryColor,
                child: CircleAvatar(
                  child:
                      SvgPicture.string(Jdenticon.toSvg(accountData.publicKey)),
                  radius: 22,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Account 1',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: 55.0,
                    child: Text(
                      accountData.publicKey,
                      style: const TextStyle(
                        fontSize: 12,
                        color: RideColors.colorLightGrayFair,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 45.0,
                    child: Text(
                      accountData.publicKey
                          .substring(accountData.publicKey.length - 4),
                      style: const TextStyle(
                        fontSize: 12,
                        color: RideColors.colorLightGrayFair,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
