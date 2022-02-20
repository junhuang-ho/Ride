import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/account.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/repository.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_holding.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:ride/services/ride/ride_ownership.dart';

part 'account.vm.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState.loading() = _AccountLoading;
  const factory AccountState.error(String? message) = _AccountError;
  const factory AccountState.data(Account account) = _AccountData;
}

class AccountVM extends StateNotifier<AccountState> {
  AccountVM(Reader read)
      : _crypto = read(cryptoProvider),
        _repository = read(repositoryProvider),
        _rideHub = read(rideHubProvider),
        _rideOwnershipService = read(rideOwnershipProvider),
        _rideCurrencyRegistryService = read(rideCurrencyRegistryProvider),
        _rideHoldingService = read(rideHoldingProvider),
        super(const AccountState.loading()) {
    init();
  }

  final Crypto _crypto;
  final Repository _repository;
  final RideHubService _rideHub;
  final RideOwnershipService _rideOwnershipService;
  final RideCurrencyRegistryService _rideCurrencyRegistryService;
  final RideHoldingService _rideHoldingService;

  Future<void> init() async {
    final privateKey = _repository.getPrivateKey();
    if (privateKey?.isEmpty ?? true) {
      state = const AccountState.error('No private key found.');
      return;
    }
    final address = await _crypto.getPublicAddress(privateKey!);
    final ethBalance = await _rideHub.getEthBalance(address);
    final wETHBlance = await _rideHub.getWETHBalance(address);
    final fiatKey = await _rideCurrencyRegistryService.getKeyFiat();
    final cryptoKey = await _rideCurrencyRegistryService.getKeyCrypto();
    final holdingInFiat =
        await _rideHoldingService.getHolding(address, fiatKey);
    final holdingInCrypto =
        await _rideHoldingService.getHolding(address, cryptoKey);
    final ownerAddress = await _rideOwnershipService.getOwner();

    state = AccountState.data(
      Account(
        isOwner: ownerAddress == address,
        publicKey: address.toString(),
        balance: ethBalance,
        wETHBalance: wETHBlance,
        holdingInFiat: holdingInFiat,
        holdingInCrypto: holdingInCrypto,
      ),
    );
  }
}

final accountProvider =
    StateNotifierProvider.autoDispose<AccountVM, AccountState>((ref) {
  return AccountVM(ref.read);
});
