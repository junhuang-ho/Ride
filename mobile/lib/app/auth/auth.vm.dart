import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/repository.dart';

part 'auth.vm.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.loading() = _AuthLoading;
  const factory AuthState.error() = _AuthError;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.unAuthenticated() = _UnAuthenticated;
}

class AuthVM extends StateNotifier<AuthState> {
  final Repository _repo;

  AuthVM(Reader read)
      : _repo = read(repositoryProvider),
        super(const AuthState.loading()) {
    getAccount();
  }

  Future<void> getAccount() async {
    bool didSetupWallet = _repo.didSetupWallet();
    String? mnemonic = _repo.getMnemonic();
    String? privateKey = _repo.getPrivateKey();
    if (privateKey?.isNotEmpty ?? false) {
      state = const AuthState.authenticated();
    } else {
      state = const AuthState.unAuthenticated();
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
}

final authProvider = StateNotifierProvider<AuthVM, AuthState>((ref) {
  return AuthVM(ref.read);
});
