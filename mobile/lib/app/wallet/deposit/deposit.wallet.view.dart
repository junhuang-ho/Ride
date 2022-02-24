import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/wallet/deposit/deposit.wallet.vm.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_radio.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class DepositWalletView extends HookConsumerWidget {
  const DepositWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depositWallet = ref.watch(depositWalletProvider);
    final depositKeyType = useState(DepositKeyType.crypto);
    final depositAmountController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            OutlinedButton(
              child: const Text('Deposit'),
              onPressed: () async {
                await ref.read(depositWalletProvider.notifier).depositToken(
                    depositKeyType.value, depositAmountController.text);
              },
            ),
          ],
          children: <Widget>[
            Row(
              children: [
                PaperRadio(
                  'Crypto',
                  groupValue: depositKeyType.value,
                  value: DepositKeyType.crypto,
                  onChanged: (value) =>
                      depositKeyType.value = value as DepositKeyType,
                ),
                PaperRadio(
                  'Fiat',
                  groupValue: depositKeyType.value,
                  value: DepositKeyType.fiat,
                  onChanged: (value) =>
                      depositKeyType.value = value as DepositKeyType,
                ),
              ],
            ),
            depositWallet.when(
              init: () => PaperInput(
                labelText: "Deposit Amount",
                hintText: 'Please enter deposit amount in Ether',
                maxLines: 1,
                controller: depositAmountController,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (message) => PaperValidationSummary([message!]),
              success: (data) => Text('Sucessfully deposit $data!!!'),
            ),
          ],
        ),
      ),
    );
  }
}
