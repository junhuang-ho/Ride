import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_holding.dart';
import 'package:ride/services/ride/ride_hub.dart';

part 'withdraw.holdings.vm.freezed.dart';

@freezed
class WithdrawHoldingsState with _$WithdrawHoldingsState {
  const factory WithdrawHoldingsState.init() = _WithdrawHoldingsInit;
  const factory WithdrawHoldingsState.loading() = _WithdrawHoldingsLoading;
  const factory WithdrawHoldingsState.error(String? message) =
      _WithdrawHoldingsError;
  const factory WithdrawHoldingsState.success(String? data) =
      _WithdrawHoldingsSuccess;
}

class WithdrawHoldingsVM extends StateNotifier<WithdrawHoldingsState> {
  WithdrawHoldingsVM(Reader read)
      : _rideHolding = read(rideHoldingProvider),
        _rideCurrencyRegistry = read(rideCurrencyRegistryProvider),
        _rideHub = read(rideHubProvider),
        super(const WithdrawHoldingsState.init());

  final RideHoldingService _rideHolding;
  final RideCurrencyRegistryService _rideCurrencyRegistry;
  final RideHubService _rideHub;

  Future<void> withdrawToken(
    String withdrawalAmount,
  ) async {
    try {
      state = const WithdrawHoldingsState.loading();

      final withdrawalAmountInWei =
          BigInt.from(double.parse(withdrawalAmount) * pow(10, 18));
      await _rideHub.authorizeWETH(withdrawalAmountInWei);
      final keyPay = await _rideCurrencyRegistry.getKeyCrypto();
      final result =
          await _rideHolding.withdrawTokens(keyPay, withdrawalAmountInWei);
      state = WithdrawHoldingsState.success(result);
    } catch (ex) {
      state = WithdrawHoldingsState.error(ex.toString());
    }
  }
}

final withdrawHoldingsProvider = StateNotifierProvider.autoDispose<
    WithdrawHoldingsVM, WithdrawHoldingsState>((ref) {
  return WithdrawHoldingsVM(ref.read);
});
