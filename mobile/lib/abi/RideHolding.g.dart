// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"decrease","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"},{"indexed":false,"internalType":"address","name":"increase","type":"address"},{"indexed":false,"internalType":"bytes32","name":"key","type":"bytes32"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"CurrencyTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"TokensDeposited","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"TokensRemoved","type":"event"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"depositTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_user","type":"address"},{"internalType":"bytes32","name":"_key","type":"bytes32"}],"name":"getHolding","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"withdrawTokens","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RideHolding');

class RideHolding extends _i1.GeneratedContract {
  RideHolding(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> depositTokens(_i2.Uint8List _key, BigInt _amount,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '222b8947'));
    final params = [_key, _amount];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getHolding(_i1.EthereumAddress _user, _i2.Uint8List _key,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'b9b09392'));
    final params = [_user, _key];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> withdrawTokens(_i2.Uint8List _key, BigInt _amount,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'c9ad5f84'));
    final params = [_key, _amount];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all CurrencyTransferred events emitted by this contract.
  Stream<CurrencyTransferred> currencyTransferredEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('CurrencyTransferred');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return CurrencyTransferred(decoded);
    });
  }

  /// Returns a live stream of all TokensDeposited events emitted by this contract.
  Stream<TokensDeposited> tokensDepositedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TokensDeposited');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TokensDeposited(decoded);
    });
  }

  /// Returns a live stream of all TokensRemoved events emitted by this contract.
  Stream<TokensRemoved> tokensRemovedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TokensRemoved');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TokensRemoved(decoded);
    });
  }
}

class CurrencyTransferred {
  CurrencyTransferred(List<dynamic> response)
      : decrease = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List),
        increase = (response[2] as _i1.EthereumAddress),
        key = (response[3] as _i2.Uint8List),
        amount = (response[4] as BigInt);

  final _i1.EthereumAddress decrease;

  final _i2.Uint8List tixId;

  final _i1.EthereumAddress increase;

  final _i2.Uint8List key;

  final BigInt amount;
}

class TokensDeposited {
  TokensDeposited(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        amount = (response[1] as BigInt);

  final _i1.EthereumAddress sender;

  final BigInt amount;
}

class TokensRemoved {
  TokensRemoved(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        amount = (response[1] as BigInt);

  final _i1.EthereumAddress sender;

  final BigInt amount;
}
