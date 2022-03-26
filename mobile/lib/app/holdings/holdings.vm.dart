import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_exchange.dart';
import 'package:ride/services/ride/ride_holding.dart';
import 'package:web3dart/web3dart.dart';

part 'holdings.vm.freezed.dart';

@freezed
class HoldingsState with _$HoldingsState {
  const factory HoldingsState.loading() = _HoldingsLoading;
  const factory HoldingsState.error(String? message) = _HoldingsError;
  const factory HoldingsState.data(
      BigInt holdingsInCrypto, BigInt holdingsInFiat) = _HoldingsData;
}

class HoldingsVM extends StateNotifier<HoldingsState> {
  HoldingsVM(Reader read)
      : _authVM = read(authProvider.notifier),
        _rideCurrencyRegistryService = read(rideCurrencyRegistryProvider),
        _rideHoldingService = read(rideHoldingProvider),
        _rideExchangeService = read(rideExchangeProvider),
        super(const HoldingsState.loading()) {
    getHoldings();
  }

  final AuthVM _authVM;
  final RideCurrencyRegistryService _rideCurrencyRegistryService;
  final RideHoldingService _rideHoldingService;
  final RideExchangeService _rideExchangeService;

  Future<void> getHoldings() async {
    try {
      state = const HoldingsState.loading();

      final address = await _authVM.getPublicKey();
      final cryptoKey = await _rideCurrencyRegistryService.getKeyCrypto();
      final fiatKey = await _rideCurrencyRegistryService.getKeyFiat();
      final holdingInCrypto = await _rideHoldingService.getHolding(
          EthereumAddress.fromHex(address!), cryptoKey);
      final holdingsInFiat = await _rideExchangeService.convertCurrency(
          cryptoKey, fiatKey, holdingInCrypto);

      state = HoldingsState.data(holdingInCrypto, holdingsInFiat);
    } catch (ex) {
      if (mounted) {
        state = HoldingsState.error(ex.toString());
      } else {
        log(ex.toString());
      }
    }
  }
}

final holdingsProvider =
    StateNotifierProvider<HoldingsVM, HoldingsState>((ref) {
  ref.watch(authProvider);

  return HoldingsVM(ref.read);
});
