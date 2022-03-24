import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/wallet/send/send.wallet.vm.dart';
import 'package:ride/app/wallet/wallet.vm.dart';
import 'package:ride/app/wallet/widgets/address_copy_button.dart';
import 'package:ride/app/wallet/widgets/wallet_app_bar.dart';
import 'package:ride/utils/eth_amount_formatter.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/paper_validation_summary.dart';
import 'package:ride/widgets/sheet_handle.dart';

class WalletView extends HookConsumerWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final wallet = ref.watch(walletProvider);

    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: WalletAppBar(
        appBarTitle: 'Wallet',
        actionWidgets: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: wallet.maybeWhen(
              loading: null,
              orElse: () => () async {
                await ref.read(walletProvider.notifier).getBalance();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: wallet.maybeWhen(
            data: (_) => MainAxisAlignment.start,
            orElse: () => MainAxisAlignment.center,
          ),
          children: [
            wallet.when(
              loading: () => const CircularProgressIndicator(),
              error: (errorMsg) => PaperValidationSummary([errorMsg!]),
              data: (walletData) => Column(
                children: [
                  AccountInfo(
                    publicKey: auth.maybeWhen(
                      authenticated: (accountData) => accountData.publicKey,
                      orElse: () => '',
                    ),
                    ethBalance: walletData.balance!.getInWei,
                  ),
                  const SizedBox(height: 25),
                  const WalletActions(),
                  const SizedBox(height: 25),
                  TabBar(
                    controller: tabController,
                    tabs: const [Tab(text: 'Tokens'), Tab(text: 'Activity')],
                  ),
                  TokensList(
                    ethBalance: walletData.balance!.getInWei,
                    tokenBalance: walletData.wETHBalance,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountInfo extends StatelessWidget {
  const AccountInfo({
    Key? key,
    required this.publicKey,
    required this.ethBalance,
  }) : super(key: key);

  final String publicKey;
  final BigInt ethBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        CircleAvatar(
          radius: 28,
          backgroundColor: RideColors.primaryColor,
          child: CircleAvatar(
            child: SvgPicture.string(Jdenticon.toSvg(publicKey)),
            radius: 25,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Account 1',
          style: TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 15),
        Text(
          '${EthAmountFormatter(ethBalance).format()} MATIC',
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 15),
        AddressCopyButton(publicKey: publicKey),
      ],
    );
  }
}

class WalletActions extends StatelessWidget {
  const WalletActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WalletActionButton(
          actionIcon: Icons.arrow_downward,
          actionText: 'Receive',
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              builder: (context) => const WalletReceiveSheet(),
            );
          },
        ),
        const SizedBox(width: 20),
        WalletActionButton(
          actionIcon: Icons.send,
          actionText: 'Send',
          onTap: () =>
              context.push('/passenger/wallet/send', extra: TokenType.matic),
        ),
      ],
    );
  }
}

class WalletActionButton extends StatelessWidget {
  const WalletActionButton({
    Key? key,
    required this.actionIcon,
    required this.actionText,
    required this.onTap,
  }) : super(key: key);

  final IconData actionIcon;
  final String actionText;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: RideColors.primaryColor,
              foregroundColor: Colors.white,
              child: Icon(actionIcon),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          actionText,
          style: const TextStyle(
            fontSize: 15,
            color: RideColors.primaryColor,
          ),
        )
      ],
    );
  }
}

class WalletReceiveSheet extends HookConsumerWidget {
  const WalletReceiveSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            spreadRadius: .5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      height: 350,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: <Widget>[
            const SheetHandle(),
            const SizedBox(height: 15),
            const Text(
              'Receive',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 15),
            if (MediaQuery.of(context).orientation == Orientation.portrait ||
                kIsWeb)
              QrImage(
                data: auth.maybeWhen(
                  authenticated: (accountData) => accountData.publicKey,
                  orElse: () => '',
                ),
                size: 150.0,
                backgroundColor: Colors.white,
              ),
            const SizedBox(height: 15),
            const Text(
              'Scan address to receive payment',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
            auth.maybeWhen(
              authenticated: (accountData) =>
                  AddressCopyButton(publicKey: accountData.publicKey),
              orElse: () => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class TokensList extends StatelessWidget {
  const TokensList({
    Key? key,
    required this.ethBalance,
    required this.tokenBalance,
  }) : super(key: key);

  final BigInt ethBalance;
  final BigInt tokenBalance;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          leading: Image.asset('images/matic-logo.png', width: 40),
          title: Text('${EthAmountFormatter(ethBalance).format()} MATIC'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () =>
              context.push('/passenger/wallet/send', extra: TokenType.matic),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
          leading: Image.asset('images/ethereum-logo.png', width: 40),
          title: Text('${EthAmountFormatter(tokenBalance).format()} WETH'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () =>
              context.push('/passenger/wallet/send', extra: TokenType.weth),
        ),
      ],
    );
  }
}
