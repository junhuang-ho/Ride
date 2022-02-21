import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_holding.dart';
import 'package:ride/services/ride/ride_hub.dart';

part 'deposit.account.vm.freezed.dart';

enum DepositKeyType { crypto, fiat }

@freezed
class DepositAccountState with _$DepositAccountState {
  const factory DepositAccountState.init() = _DepositAccountInit;
  const factory DepositAccountState.loading() = _DepositAccountLoading;
  const factory DepositAccountState.error(String? message) =
      _DepositAccountError;
  const factory DepositAccountState.success(String? data) =
      _DepositAccountSuccess;
}

class DepositAccountVM extends StateNotifier<DepositAccountState> {
  DepositAccountVM(Reader read)
      : _rideHolding = read(rideHoldingProvider),
        _rideCurrencyRegistry = read(rideCurrencyRegistryProvider),
        _rideHub = read(rideHubProvider),
        super(const DepositAccountState.init());

  final RideHoldingService _rideHolding;
  final RideCurrencyRegistryService _rideCurrencyRegistry;
  final RideHubService _rideHub;

  Future<void> depositToken(
    DepositKeyType keyType,
    String depositAmount,
  ) async {
    try {
      state = const DepositAccountState.loading();
      final parsedAmount = BigInt.parse(depositAmount);
      final authorizationResult = await _rideHub.authorizeWETH(parsedAmount);
      print('authorizationResult: $authorizationResult');
      final keyPay = keyType == DepositKeyType.crypto
          ? await _rideCurrencyRegistry.getKeyCrypto()
          : await _rideCurrencyRegistry.getKeyFiat();
      final result = await _rideHolding.depositTokens(keyPay, parsedAmount);
      print('result: $result');
      state = DepositAccountState.success(result);
    } catch (ex) {
      state = DepositAccountState.error(ex.toString());
    }
  }
}

final depositAccountProvider =
    StateNotifierProvider.autoDispose<DepositAccountVM, DepositAccountState>(
        (ref) {
  return DepositAccountVM(ref.read);
});
