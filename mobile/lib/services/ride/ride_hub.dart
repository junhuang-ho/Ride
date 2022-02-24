import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web_socket_channel/io.dart';

class RideHubService {
  late Credentials _credentials;
  late Client _httpClient;
  late Web3Client _web3Client;
  late Erc20 _wethToken;
  final String rpcUrl = 'https://rpc-mumbai.matic.today';
  final String wsAddress = 'wss://ws-mumbai.matic.today';

  final wethAddress =
      EthereumAddress.fromHex('0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa');
  final rideHubAddress =
      EthereumAddress.fromHex('0x2554FAc78F53b92d57999A635985518D7b3edb43');

  Credentials get credentials => _credentials;
  Web3Client get web3Client => _web3Client;

  RideHubService() {
    _httpClient = Client();
    _web3Client = Web3Client(
      rpcUrl,
      _httpClient,
      socketConnector: () {
        return IOWebSocketChannel.connect(wsAddress).cast<String>();
      },
    );
    _wethToken = Erc20(address: wethAddress, client: _web3Client);
  }

  void setCredentials(String privateKey) async {
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<EtherAmount> getEthBalance(EthereumAddress from) async {
    return await _web3Client.getBalance(from);
  }

  Future<BigInt> getWETHBalance(EthereumAddress from) async {
    return await _wethToken.balanceOf(from);
  }

  Future<String?> sendWETH(
    EthereumAddress to,
    EtherAmount amount,
  ) async {
    final transactionId = await _wethToken.transfer(to, amount.getInWei,
        credentials: credentials);
    return transactionId;
  }

  Future<String> authorizeWETH(BigInt amount) async {
    final transactionId = await _wethToken.approve(rideHubAddress, amount,
        credentials: _credentials);
    return transactionId;
  }
}

final rideHubProvider = Provider<RideHubService>((ref) {
  return RideHubService();
});
