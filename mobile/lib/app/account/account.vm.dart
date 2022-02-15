import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/account.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/repository.dart';
import 'package:ride/services/ride/ride_ownership.dart';
import 'package:ride/services/web3.dart';

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
        _web3 = read(web3Provider),
        _rideOwnershipService = read(rideOwnershipProvider),
        super(const AccountState.loading()) {
    init();
  }

  final Crypto _crypto;
  final Repository _repository;
  final Web3 _web3;
  final RideOwnershipService _rideOwnershipService;

  Future<void> init() async {
    final privateKey = _repository.getPrivateKey();
    if (privateKey?.isEmpty ?? true) {
      state = const AccountState.error('No private key found.');
      return;
    }
    final address = await _crypto.getPublicAddress(privateKey!);
    final ethBalance = await _web3.getEthBalance(address);
    final ownerAddress = await _rideOwnershipService.getOwner();

    state = AccountState.data(Account(
      isOwner: ownerAddress == address,
      publicKey: address.toString(),
      balance: ethBalance,
    ));
  }
}

final accountProvider =
    StateNotifierProvider.autoDispose<AccountVM, AccountState>((ref) {
  return AccountVM(ref.read);
});
