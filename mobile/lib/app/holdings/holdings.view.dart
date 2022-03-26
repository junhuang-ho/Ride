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
              data: (holdingsInCrypto, holdingsInFiat) => RideHoldingsCard(
                holdingsInCrypto: holdingsInCrypto,
                holdingsInFiat: holdingsInFiat,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RideHoldingsCard extends HookConsumerWidget {
  const RideHoldingsCard({
    Key? key,
    required this.holdingsInCrypto,
    required this.holdingsInFiat,
  }) : super(key: key);

  final BigInt holdingsInCrypto;
  final BigInt holdingsInFiat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: RideColors.cardColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ride Holdings',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${EthAmountFormatter(holdingsInCrypto).format()} WETH',
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${EthAmountFormatter(holdingsInFiat).formatFiat()}',
                  style: const TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Crypto, Fiat, Now Both',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: RideColors.lightGrayColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MaterialButton(
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
                    ),
                    const VerticalDivider(
                      color: RideColors.lightGrayColor,
                      thickness: 1,
                      indent: 20,
                      endIndent: 0,
                      width: 20,
                    ),
                    Expanded(
                      child: MaterialButton(
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
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
