import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ride/app/wallet/setup.wallet.vm.dart';
import 'package:ride/app/wallet/widgets/confirm_mnemonic.dart';
import 'package:ride/app/wallet/widgets/display_mnemonic.dart';

class CreateWalletView extends HookConsumerWidget {
  const CreateWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupWallet = ref.watch(setupWalletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Wallet'),
      ),
      body: setupWallet.whenOrNull(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        display: (mnemonic) => DisplayMnemonic(
          mnemonic: mnemonic,
          onNext: () {
            ref.read(setupWalletProvider.notifier).goToConfirm(mnemonic);
          },
        ),
        confirm: (generatedMnemonic) => ConfirmMnemonic(
          onConfirm: (confirmedMnemonic) async {
            bool setupSuccess = await ref
                .read(setupWalletProvider.notifier)
                .confirmMnemonic(
                    generatedMnemonic: generatedMnemonic,
                    mnemonic: confirmedMnemonic);
            if (setupSuccess) {
              context.go('/');
            }
          },
          onGenerateNew: () {
            ref.read(setupWalletProvider.notifier).generateMnemonic();
          },
        ),
      ),
    );
  }
}
