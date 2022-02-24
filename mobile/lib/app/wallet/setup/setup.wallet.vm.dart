import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/services/crypto.dart';

part 'setup.wallet.vm.freezed.dart';

enum WalletImportType { mnemonic, privateKey }

@freezed
class SetupWalletState with _$SetupWalletState {
  const factory SetupWalletState.init() = _SetupWalletInit;
  const factory SetupWalletState.loading() = _SetupWalletLoading;
  const factory SetupWalletState.error(String? message) = _SetupWalletError;
  const factory SetupWalletState.display({
    required String mnemonic,
  }) = _SetupWalletDisplay;
  const factory SetupWalletState.confirm({
    required String generatedMnemonic,
  }) = _SetupWalletConfirm;
}

class SetupWalletVM extends StateNotifier<SetupWalletState> {
  SetupWalletVM(Reader read)
      : _crypto = read(cryptoProvider),
        _authVM = read(authProvider.notifier),
        super(const SetupWalletState.init());

  final Crypto _crypto;
  final AuthVM _authVM;

  void generateMnemonic() {
    final mnemonic = _crypto.generateMnemonic();
    state = SetupWalletState.display(mnemonic: mnemonic);
  }

  void goToConfirm(String generatedMnemonic) {
    state = SetupWalletState.confirm(generatedMnemonic: generatedMnemonic);
  }

  Future<bool> confirmMnemonic({
    required String generatedMnemonic,
    required String mnemonic,
  }) async {
    if (generatedMnemonic != mnemonic) {
      state =
          const SetupWalletState.error('Invalid mnemonic, please try again.');
      return false;
    }
    state = const SetupWalletState.loading();
    await _crypto.setupFromMnemonic(mnemonic);
    await _authVM.getAccount();

    return true;
  }

  Future<bool> importFromMnemonic(String mnemonic) async {
    try {
      state = const SetupWalletState.loading();
      if (_validateMnemonic(mnemonic)) {
        final normalisedMnemonic = _mnemonicNormalise(mnemonic);
        await _crypto.setupFromMnemonic(normalisedMnemonic);
        await _authVM.getAccount();
        return true;
      } else {
        state = const SetupWalletState.error(
            'Invalid mnemonic, it requires 12 words.');
        return false;
      }
    } catch (e) {
      state = SetupWalletState.error(e.toString());
      return false;
    }
  }

  Future<bool> importFromPrivateKey(String privateKey) async {
    try {
      state = const SetupWalletState.loading();
      await _crypto.setupFromPrivateKey(privateKey);
      await _authVM.getAccount();
      return true;
    } catch (e) {
      state = SetupWalletState.error(e.toString());
      return false;
    }
  }

  bool _validateMnemonic(String mnemonic) {
    return _mnemonicWords(mnemonic).length == 12;
  }

  String _mnemonicNormalise(String mnemonic) {
    return _mnemonicWords(mnemonic).join(' ');
  }

  List<String> _mnemonicWords(String mnemonic) {
    return mnemonic
        .split(' ')
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toList();
  }
}

final setupWalletProvider =
    StateNotifierProvider.autoDispose<SetupWalletVM, SetupWalletState>((ref) {
  return SetupWalletVM(ref.read);
});
