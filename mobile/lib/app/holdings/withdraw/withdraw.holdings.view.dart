import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/holdings/holdings.vm.dart';
import 'package:ride/app/holdings/withdraw/withdraw.holdings.vm.dart';
import 'package:ride/utils/eth_amount_formatter.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class WithdrawWalletView extends HookConsumerWidget {
  const WithdrawWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawHoldings = ref.watch(withdrawHoldingsProvider);
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
                    .read(withdrawHoldingsProvider.notifier)
                    .withdrawToken(withdrawAmountController.text);
              },
            ),
          ],
          children: <Widget>[
            const Text(
              'From Ride Holdings',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 15),
            withdrawHoldings.when(
              init: () => PaperInput(
                labelText: "Withdrawal Amount (WETH)",
                hintText: 'Please enter withdrawal amount in Ether',
                maxLines: 1,
                controller: withdrawAmountController,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (message) => PaperValidationSummary([message!]),
              success: (data) => Text('Sucessfully withdraw $data!!!'),
            ),
            const SizedBox(height: 15),
            Consumer(builder: (context, ref, _) {
              final holdings = ref.watch(holdingsProvider);

              return Container(
                color: RideColors.grey,
                padding: const EdgeInsets.all(8.0),
                child: holdings.when(
                  loading: () => SpinKitThreeBounce(),
                  error: (errorMsg) => Text(errorMsg!),
                  data: (holdingsData) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Available: ',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              '${EthAmountFormatter(holdingsData).formatFiat(decimalPoint: 10)} WETH',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextButton(
                          child: const Text(
                            'Full Withdrawal',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          onPressed: () {
                            withdrawAmountController.text =
                                EthAmountFormatter(holdingsData).format();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
