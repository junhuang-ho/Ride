import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/contracts/erc20.dart';

class RideHubService {
  late Credentials _credentials;
  late Client _httpClient;
  late Web3Client _web3client;
  late Erc20 _wethToken;
  final String rpcUrl = 'https://matic-mumbai.chainstacklabs.com/';
  final wethAddress =
      EthereumAddress.fromHex('0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa');
  final rideHubAddress =
      EthereumAddress.fromHex('0x2554FAc78F53b92d57999A635985518D7b3edb43');

  Credentials get credentials => _credentials;
  Web3Client get web3Client => _web3client;

  RideHubService() {
    _httpClient = Client();
    _web3client = Web3Client(rpcUrl, _httpClient);
    _wethToken = Erc20(address: wethAddress, client: _web3client);
  }

  void setCredentials(String privateKey) async {
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<EtherAmount> getEthBalance(EthereumAddress from) async {
    return await web3Client.getBalance(from);
  }
}

final rideHubProvider = Provider<RideHubService>((ref) {
  return RideHubService();
});
