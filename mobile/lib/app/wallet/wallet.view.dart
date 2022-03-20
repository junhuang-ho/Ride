import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/wallet/widgets/balance.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/wallet/wallet.vm.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class WalletView extends HookConsumerWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final wallet = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: wallet.maybeWhen(
              loading: null,
              orElse: () => () async {
                await ref.read(walletProvider.notifier).getBalance();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: wallet.maybeWhen(
              loading: null,
              orElse: () => () {
                context.push('/passenger/wallet/send');
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            wallet.when(
              loading: () => const CircularProgressIndicator(),
              error: (errorMsg) => PaperValidationSummary([errorMsg!]),
              data: (walletData) => Balance(
                address: auth.maybeWhen(
                  authenticated: (accountData) => accountData.publicKey,
                  orElse: () => '',
                ),
                ethBalance: walletData.balance!.getInWei,
                tokenBalance: walletData.wETHBalance,
                holdingInCrypto: walletData.holdingInCrypto,
                symbol: 'MATIC',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
