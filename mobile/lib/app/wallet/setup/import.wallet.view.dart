import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ride/app/wallet/setup/setup.wallet.vm.dart';
import 'package:ride/app/wallet/widgets/import_wallet_form.dart';

class ImportWalletView extends HookConsumerWidget {
  const ImportWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupWallet = ref.watch(setupWalletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Wallet'),
      ),
      body: ImportWalletForm(
        onImport: setupWallet.maybeWhen(
          loading: null,
          orElse: () => (type, value) async {
            final setupWalletVM = ref.read(setupWalletProvider.notifier);
            switch (type) {
              case WalletImportType.mnemonic:
                if (!await setupWalletVM.importFromMnemonic(value)) {
                  return;
                }
                break;
              case WalletImportType.privateKey:
                if (!await setupWalletVM.importFromPrivateKey(value)) {
                  return;
                }
                break;
              default:
                break;
            }
            context.go('/');
          },
        ),
      ),
    );
  }
}
