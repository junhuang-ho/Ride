import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/holdings/withdraw/withdraw.wallet.vm.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class WithdrawWalletView extends HookConsumerWidget {
  const WithdrawWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawWallet = ref.watch(withdrawWalletProvider);
    final withdrawAmountController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal'),
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            OutlinedButton(
              child: const Text('Withdraw'),
              onPressed: () async {
                await ref
                    .read(withdrawWalletProvider.notifier)
                    .withdrawToken(withdrawAmountController.text);
              },
            ),
          ],
          children: <Widget>[
            withdrawWallet.when(
              init: () => PaperInput(
                labelText: "Withdrawal Amount",
                hintText: 'Please enter withdrawal amount in Ether',
                maxLines: 1,
                controller: withdrawAmountController,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (message) => PaperValidationSummary([message!]),
              success: (data) => Text('Sucessfully withdraw $data!!!'),
            ),
          ],
        ),
      ),
    );
  }
}
