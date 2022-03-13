import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_holding.dart';
import 'package:ride/services/ride/ride_hub.dart';

part 'withdraw.wallet.vm.freezed.dart';

@freezed
class WithdrawWalletState with _$WithdrawWalletState {
  const factory WithdrawWalletState.init() = _WithdrawWalletInit;
  const factory WithdrawWalletState.loading() = _WithdrawWalletLoading;
  const factory WithdrawWalletState.error(String? message) =
      _WithdrawWalletError;
  const factory WithdrawWalletState.success(String? data) =
      _WithdrawWalletSuccess;
}

class WithdrawWalletVM extends StateNotifier<WithdrawWalletState> {
  WithdrawWalletVM(Reader read)
      : _rideHolding = read(rideHoldingProvider),
        _rideCurrencyRegistry = read(rideCurrencyRegistryProvider),
        _rideHub = read(rideHubProvider),
        super(const WithdrawWalletState.init());

  final RideHoldingService _rideHolding;
  final RideCurrencyRegistryService _rideCurrencyRegistry;
  final RideHubService _rideHub;

  Future<void> withdrawToken(
    String withdrawalAmount,
  ) async {
    try {
      state = const WithdrawWalletState.loading();

      final withdrawalAmountInWei =
          BigInt.from(double.parse(withdrawalAmount) * pow(10, 18));
      await _rideHub.authorizeWETH(withdrawalAmountInWei);
      final keyPay = await _rideCurrencyRegistry.getKeyCrypto();
      final result =
          await _rideHolding.withdrawTokens(keyPay, withdrawalAmountInWei);
      state = WithdrawWalletState.success(result);
    } catch (ex) {
      state = WithdrawWalletState.error(ex.toString());
    }
  }
}

final withdrawWalletProvider =
    StateNotifierProvider.autoDispose<WithdrawWalletVM, WithdrawWalletState>(
        (ref) {
  return WithdrawWalletVM(ref.read);
});
