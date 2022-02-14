import 'package:http/http.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3dart/web3dart.dart';

class Web3 {
  late Client httpClient;
  late Web3Client ethClient;
  String rpcUrl = 'https://matic-mumbai.chainstacklabs.com/';

  final greeterContractAddress =
      EthereumAddress.fromHex('0x579Eb6c7c1E6AE8A73B433166B02a9f42bFb2CDB');

  final rideHubAddress =
      EthereumAddress.fromHex('0x2554FAc78F53b92d57999A635985518D7b3edb43');

  late Credentials _credentials;

  Web3() {
    httpClient = Client();
    ethClient = Web3Client(rpcUrl, httpClient);
  }

  void setCredentials(String privateKey) async {
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<EtherAmount> getEthBalance(EthereumAddress from) async {
    return await ethClient.getBalance(from);
  }
}

final web3Provider = Provider<Web3>((ref) {
  return Web3();
});
