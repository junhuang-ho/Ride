import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/holdings/holdings.vm.dart';
import 'package:ride/app/wallet/widgets/wallet_app_bar.dart';
import 'package:ride/utils/eth_amount_formatter.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class HoldingsView extends HookConsumerWidget {
  const HoldingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdings = ref.watch(holdingsProvider);

    return Scaffold(
      appBar: WalletAppBar(
        appBarTitle: 'Ride Holdings',
        actionWidgets: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: holdings.maybeWhen(
              loading: null,
              orElse: () => () async {
                await ref.read(holdingsProvider.notifier).getHoldings();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            holdings.when(
              loading: () => const CircularProgressIndicator(),
              error: (errorMsg) => PaperValidationSummary([errorMsg!]),
              data: (holdingsData) => Column(
                children: [
                  const Text(
                    'Ride Holdings Amount',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${EthAmountFormatter(holdingsData).format()} WETH',
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    height: 55,
                    color: RideColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onPressed: () =>
                        context.push('/passenger/holdings/deposit'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Deposit'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    height: 55,
                    color: RideColors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onPressed: () =>
                        context.push('/passenger/holdings/withdraw'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Withdraw'),
                    ),
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
