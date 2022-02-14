import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  Repository(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  bool didSetupWallet() {
    return _sharedPreferences.getBool('didSetupWallet') ?? false;
  }

  String? getMnemonic() {
    return _sharedPreferences.getString('mnemonic');
  }

  String? getPrivateKey() {
    return _sharedPreferences.getString('privateKey');
  }

  Future<void> setupDone(bool value) async {
    await _sharedPreferences.setBool('didSetupWallet', value);
  }

  Future<void> setMnemonic(String? value) async {
    await _sharedPreferences.setString('mnemonic', value ?? '');
  }

  Future<void> setPrivateKey(String? value) async {
    await _sharedPreferences.setString('privateKey', value ?? '');
  }
}

final repositoryProvider =
    Provider<Repository>((ref) => throw UnimplementedError());
