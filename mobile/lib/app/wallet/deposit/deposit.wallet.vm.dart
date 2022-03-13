import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_holding.dart';
import 'package:ride/services/ride/ride_hub.dart';

part 'deposit.wallet.vm.freezed.dart';

enum DepositKeyType { crypto, fiat }

@freezed
class DepositWalletState with _$DepositWalletState {
  const factory DepositWalletState.init() = _DepositWalletInit;
  const factory DepositWalletState.loading() = _DepositWalletLoading;
  const factory DepositWalletState.error(String? message) = _DepositWalletError;
  const factory DepositWalletState.success(String? data) =
      _DepositWalletSuccess;
}

class DepositWalletVM extends StateNotifier<DepositWalletState> {
  DepositWalletVM(Reader read)
      : _rideHolding = read(rideHoldingProvider),
        _rideCurrencyRegistry = read(rideCurrencyRegistryProvider),
        _rideHub = read(rideHubProvider),
        super(const DepositWalletState.init());

  final RideHoldingService _rideHolding;
  final RideCurrencyRegistryService _rideCurrencyRegistry;
  final RideHubService _rideHub;

  Future<void> depositToken(
    String depositAmount,
  ) async {
    try {
      state = const DepositWalletState.loading();

      final depositAmountInWei =
          BigInt.from(double.parse(depositAmount) * pow(10, 18));
      await _rideHub.authorizeWETH(depositAmountInWei);
      final keyPay = await _rideCurrencyRegistry.getKeyCrypto();
      final result =
          await _rideHolding.depositTokens(keyPay, depositAmountInWei);
      state = DepositWalletState.success(result);
    } catch (ex) {
      state = DepositWalletState.error(ex.toString());
    }
  }
}

final depositWalletProvider =
    StateNotifierProvider.autoDispose<DepositWalletVM, DepositWalletState>(
        (ref) {
  return DepositWalletVM(ref.read);
});
