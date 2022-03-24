import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_holding.dart';
import 'package:ride/services/ride/ride_hub.dart';

part 'deposit.holdings.vm.freezed.dart';

enum DepositKeyType { crypto, fiat }

@freezed
class DepositHoldingsState with _$DepositHoldingsState {
  const factory DepositHoldingsState.init() = _DepositHoldingsInit;
  const factory DepositHoldingsState.loading() = _DepositHoldingsLoading;
  const factory DepositHoldingsState.error(String? message) =
      _DepositHoldingsError;
  const factory DepositHoldingsState.success(String? data) =
      _DepositHoldingsSuccess;
}

class DepositHoldingsVM extends StateNotifier<DepositHoldingsState> {
  DepositHoldingsVM(Reader read)
      : _rideHolding = read(rideHoldingProvider),
        _rideCurrencyRegistry = read(rideCurrencyRegistryProvider),
        _rideHub = read(rideHubProvider),
        super(const DepositHoldingsState.init());

  final RideHoldingService _rideHolding;
  final RideCurrencyRegistryService _rideCurrencyRegistry;
  final RideHubService _rideHub;

  Future<void> depositToken(
    String depositAmount,
  ) async {
    try {
      state = const DepositHoldingsState.loading();

      final depositAmountInWei =
          BigInt.from(double.parse(depositAmount) * pow(10, 18));
      await _rideHub.authorizeWETH(depositAmountInWei);
      final keyPay = await _rideCurrencyRegistry.getKeyCrypto();
      final result =
          await _rideHolding.depositTokens(keyPay, depositAmountInWei);
      state = DepositHoldingsState.success(result);
    } catch (ex) {
      state = DepositHoldingsState.error(ex.toString());
    }
  }
}

final depositHoldingsProvider =
    StateNotifierProvider.autoDispose<DepositHoldingsVM, DepositHoldingsState>(
        (ref) {
  return DepositHoldingsVM(ref.read);
});
