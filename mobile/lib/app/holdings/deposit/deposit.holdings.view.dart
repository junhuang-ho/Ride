import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/holdings/deposit/deposit.holdings.vm.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class DepositHoldingsView extends HookConsumerWidget {
  const DepositHoldingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depositHoldings = ref.watch(depositHoldingsProvider);
    final depositAmountController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            MaterialButton(
              height: 35,
              minWidth: 100,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () async {
                await ref
                    .read(depositHoldingsProvider.notifier)
                    .depositToken(depositAmountController.text);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Deposit'),
              ),
            ),
          ],
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: RideColors.grey,
              child: Container(
                margin: const EdgeInsets.all(4),
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.privacy_tip),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        'Note: Deposit to Ride Holdings ONLY',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            depositHoldings.when(
              init: () => PaperInput(
                labelText: "Deposit Amount",
                hintText: 'Please enter deposit amount in Ether',
                maxLines: 1,
                controller: depositAmountController,
                keyboardType: TextInputType.number,
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
