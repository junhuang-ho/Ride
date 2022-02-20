import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/account/account.vm.dart';
import 'package:ride/app/account/widgets/balance.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class AccountView extends HookConsumerWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.savings),
            onPressed: account.maybeWhen(
              loading: null,
              orElse: () => () {
                context.push('/home/account/deposit');
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            account.when(
              loading: () => const CircularProgressIndicator(),
              error: (errorMsg) => PaperValidationSummary([errorMsg!]),
              data: (accountData) => Balance(
                address: accountData.publicKey,
                ethBalance: accountData.balance!.getInWei,
                tokenBalance: accountData.wETHBalance,
                holdingInCrypto: accountData.holdingInCrypto,
                holdingInFiat: accountData.holdingInFiat,
                symbol: 'MATIC',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
