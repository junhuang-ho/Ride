import 'package:convert/convert.dart';

import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:ride/services/repository.dart';

class Crypto {
  Crypto(Reader read) : _repo = read(repositoryProvider);

  final Repository _repo;

  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  String getMnemonic(String entropyString) {
    return bip39.entropyToMnemonic(entropyString);
  }

  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeedHex(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(hex.decode(seed),
        masterSecret: 'Bitcoin seed');
    final privateKey = HEX.encode(master.key);
    return privateKey;
  }

  Future<EthereumAddress> getPublicAddress(String privateKey) async {
    final ethPrivateKey = EthPrivateKey.fromHex(privateKey);
    final address = await ethPrivateKey.extractAddress();
    return address;
  }

  Future<EthereumAddress> getUserPublicAddress() async {
    final privateKey = _repo.getPrivateKey();
    final ethPrivateKey = EthPrivateKey.fromHex(privateKey!);
    final address = await ethPrivateKey.extractAddress();
    return address;
  }

  Future<void> setupFromMnemonic(String mnemonic) async {
    final cryptMnemonic = bip39.mnemonicToEntropy(mnemonic);
    final privateKey = await getPrivateKey(mnemonic);

    await _repo.setMnemonic(cryptMnemonic);
    await _repo.setPrivateKey(privateKey);
    await _repo.setupDone(true);
  }

  Future<void> setupFromPrivateKey(String privateKey) async {
    await _repo.setMnemonic(null);
    await _repo.setPrivateKey(privateKey);
    await _repo.setupDone(true);
  }
}

final cryptoProvider = Provider<Crypto>((ref) {
  return Crypto(ref.read);
});
