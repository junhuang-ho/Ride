// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"bytes32","name":"keyX","type":"bytes32"},{"indexed":false,"internalType":"bytes32","name":"keyY","type":"bytes32"},{"indexed":false,"internalType":"address","name":"priceFeed","type":"address"}],"name":"PriceFeedAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"address","name":"priceFeed","type":"address"}],"name":"PriceFeedRemoved","type":"event"},{"inputs":[{"internalType":"bytes32","name":"_keyX","type":"bytes32"},{"internalType":"bytes32","name":"_keyY","type":"bytes32"},{"internalType":"address","name":"_priceFeed","type":"address"}],"name":"addXPerYPriceFeed","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_keyX","type":"bytes32"},{"internalType":"bytes32","name":"_keyY","type":"bytes32"},{"internalType":"uint256","name":"_amountX","type":"uint256"}],"name":"convertCurrency","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_keyX","type":"bytes32"},{"internalType":"bytes32","name":"_keyY","type":"bytes32"}],"name":"getXPerYPriceFeed","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_keyX","type":"bytes32"},{"internalType":"bytes32","name":"_keyY","type":"bytes32"}],"name":"removeXPerYPriceFeed","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RideExchange');

class RideExchange extends _i1.GeneratedContract {
  RideExchange(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> addXPerYPriceFeed(
      _i2.Uint8List _keyX, _i2.Uint8List _keyY, _i1.EthereumAddress _priceFeed,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '2c62cc9a'));
    final params = [_keyX, _keyY, _priceFeed];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> convertCurrency(
      _i2.Uint8List _keyX, _i2.Uint8List _keyY, BigInt _amountX,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '8db6dbcc'));
    final params = [_keyX, _keyY, _amountX];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> getXPerYPriceFeed(
      _i2.Uint8List _keyX, _i2.Uint8List _keyY,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '1615abe9'));
    final params = [_keyX, _keyY];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeXPerYPriceFeed(_i2.Uint8List _keyX, _i2.Uint8List _keyY,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'f31b77fb'));
    final params = [_keyX, _keyY];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all PriceFeedAdded events emitted by this contract.
  Stream<PriceFeedAdded> priceFeedAddedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('PriceFeedAdded');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return PriceFeedAdded(decoded);
    });
  }

  /// Returns a live stream of all PriceFeedRemoved events emitted by this contract.
  Stream<PriceFeedRemoved> priceFeedRemovedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('PriceFeedRemoved');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return PriceFeedRemoved(decoded);
    });
  }
}

class PriceFeedAdded {
  PriceFeedAdded(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        keyX = (response[1] as _i2.Uint8List),
        keyY = (response[2] as _i2.Uint8List),
        priceFeed = (response[3] as _i1.EthereumAddress);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List keyX;

  final _i2.Uint8List keyY;

  final _i1.EthereumAddress priceFeed;
}

class PriceFeedRemoved {
  PriceFeedRemoved(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        priceFeed = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress priceFeed;
}
