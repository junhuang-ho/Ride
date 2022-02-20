// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"bytes32","name":"key","type":"bytes32"}],"name":"CurrencyRegistered","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"bytes32","name":"key","type":"bytes32"}],"name":"CurrencyRemoved","type":"event"},{"inputs":[{"internalType":"address","name":"_token","type":"address"}],"name":"getKeyCrypto","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"_code","type":"string"}],"name":"getKeyFiat","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"}],"name":"registerCrypto","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"_code","type":"string"}],"name":"registerFiat","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"}],"name":"removeCurrency","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"},{"internalType":"uint256","name":"_cancellationFee","type":"uint256"},{"internalType":"uint256","name":"_baseFee","type":"uint256"},{"internalType":"uint256","name":"_costPerMinute","type":"uint256"},{"internalType":"uint256[]","name":"_costPerMetre","type":"uint256[]"}],"name":"setupCryptoWithFee","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"_code","type":"string"},{"internalType":"uint256","name":"_cancellationFee","type":"uint256"},{"internalType":"uint256","name":"_baseFee","type":"uint256"},{"internalType":"uint256","name":"_costPerMinute","type":"uint256"},{"internalType":"uint256[]","name":"_costPerMetre","type":"uint256[]"}],"name":"setupFiatWithFee","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"nonpayable","type":"function"}]',
    'RideCurrencyRegistry');

class RideCurrencyRegistry extends _i1.GeneratedContract {
  RideCurrencyRegistry(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> getKeyCrypto(_i1.EthereumAddress _token,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, 'b59f2672'));
    final params = [_token];
    final response = await read(function, params, atBlock);
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> getKeyFiat(String _code,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '068514c0'));
    final params = [_code];
    final response = await read(function, params, atBlock);
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> registerCrypto(_i1.EthereumAddress _token,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '23a6c38b'));
    final params = [_token];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> registerFiat(String _code,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '97d44848'));
    final params = [_code];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeCurrency(_i2.Uint8List _key,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'efd4ad5a'));
    final params = [_key];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setupCryptoWithFee(
      _i1.EthereumAddress _token,
      BigInt _cancellationFee,
      BigInt _baseFee,
      BigInt _costPerMinute,
      List<BigInt> _costPerMetre,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '8dfcb7a1'));
    final params = [
      _token,
      _cancellationFee,
      _baseFee,
      _costPerMinute,
      _costPerMetre
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setupFiatWithFee(String _code, BigInt _cancellationFee,
      BigInt _baseFee, BigInt _costPerMinute, List<BigInt> _costPerMetre,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '6f55edd3'));
    final params = [
      _code,
      _cancellationFee,
      _baseFee,
      _costPerMinute,
      _costPerMetre
    ];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all CurrencyRegistered events emitted by this contract.
  Stream<CurrencyRegistered> currencyRegisteredEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('CurrencyRegistered');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return CurrencyRegistered(decoded);
    });
  }

  /// Returns a live stream of all CurrencyRemoved events emitted by this contract.
  Stream<CurrencyRemoved> currencyRemovedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('CurrencyRemoved');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return CurrencyRemoved(decoded);
    });
  }
}

class CurrencyRegistered {
  CurrencyRegistered(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        key = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List key;
}

class CurrencyRemoved {
  CurrencyRemoved(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        key = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List key;
}
