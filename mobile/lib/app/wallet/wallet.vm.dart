import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/wallet.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/repository.dart';
import 'package:ride/services/ride/ride_currency_registry.dart';
import 'package:ride/services/ride/ride_holding.dart';
import 'package:ride/services/ride/ride_hub.dart';

part 'wallet.vm.freezed.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState.loading() = _WalletLoading;
  const factory WalletState.error(String? message) = _WalletError;
  const factory WalletState.data(Wallet walletData) = _WalletData;
}

class WalletVM extends StateNotifier<WalletState> {
  WalletVM(Reader read)
      : _crypto = read(cryptoProvider),
        _repository = read(repositoryProvider),
        _rideHub = read(rideHubProvider),
        _rideCurrencyRegistryService = read(rideCurrencyRegistryProvider),
        _rideHoldingService = read(rideHoldingProvider),
        super(const WalletState.loading()) {
    init();
  }

  final Crypto _crypto;
  final Repository _repository;
  final RideHubService _rideHub;
  final RideCurrencyRegistryService _rideCurrencyRegistryService;
  final RideHoldingService _rideHoldingService;

  Future<void> init() async {
    final privateKey = _repository.getPrivateKey();
    if (privateKey?.isEmpty ?? true) {
      state = const WalletState.error('No private key found.');
      return;
    }
    final address = await _crypto.getPublicAddress(privateKey!);
    final ethBalance = await _rideHub.getEthBalance(address);
    final wETHBlance = await _rideHub.getWETHBalance(address);
    final cryptoKey = await _rideCurrencyRegistryService.getKeyCrypto();
    final holdingInCrypto =
        await _rideHoldingService.getHolding(address, cryptoKey);

    state = WalletState.data(
      Wallet(
        balance: ethBalance,
        wETHBalance: wETHBlance,
        holdingInCrypto: holdingInCrypto,
      ),
    );
  }
}

final walletProvider = StateNotifierProvider<WalletVM, WalletState>((ref) {
  return WalletVM(ref.read);
});
