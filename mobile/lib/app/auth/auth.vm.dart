import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/account.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/repository.dart';
import 'package:ride/services/ride/ride_badge.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:ride/services/ride/ride_ownership.dart';
import 'package:web3dart/web3dart.dart';

part 'auth.vm.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.loading() = _AuthLoading;
  const factory AuthState.error(String? message) = _AuthError;
  const factory AuthState.authenticated(Account account) = _Authenticated;
  const factory AuthState.unAuthenticated() = _UnAuthenticated;
}

class AuthVM extends StateNotifier<AuthState> {
  AuthVM(Reader read)
      : _read = read,
        _crypto = read(cryptoProvider),
        _repo = read(repositoryProvider),
        _rideHub = read(rideHubProvider),
        super(const AuthState.loading()) {
    getAccount();
  }

  final Reader _read;
  final Crypto _crypto;
  final Repository _repo;
  final RideHubService _rideHub;

  Future<void> getAccount() async {
    try {
      String? privateKey = _repo.getPrivateKey();
      if (privateKey?.isNotEmpty ?? false) {
        _rideHub.setCredentials(privateKey!);
        final address = await _crypto.getPublicAddress(privateKey);

        state = AuthState.authenticated(
          Account(
            accountType: await getAccountType(address),
            publicKey: address.toString(),
          ),
        );
      } else {
        state = const AuthState.unAuthenticated();
      }
    } catch (ex) {
      state = AuthState.error(ex.toString());
    }
  }

  Future<void> deleteAccount() async {
    await _repo.setMnemonic(null);
    await _repo.setPrivateKey(null);
    await _repo.setupDone(false);
    state = const AuthState.unAuthenticated();
  }

  String? getPrivateKey() {
    return _repo.getPrivateKey();
  }

  Future<AccountType> getAccountType(EthereumAddress accountAddress) async {
    // Can ONLY read afte the credentials has been set in RideHubService
    final _rideOwnership = _read(rideOwnershipProvider);
    final _rideBadge = _read(rideBadgeProvider);

    final adminAddress = await _rideOwnership.getOwner();
    final driverReputation =
        await _rideBadge.getDriverReputation(accountAddress);

    if (accountAddress == adminAddress) {
      return AccountType.admin;
    } else if (driverReputation.id > BigInt.zero) {
      return AccountType.driver;
    } else {
      return AccountType.passenger;
    }
  }
}

final authProvider = StateNotifierProvider<AuthVM, AuthState>((ref) {
  return AuthVM(ref.read);
});
