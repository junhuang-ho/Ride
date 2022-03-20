// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"fee","type":"uint256"}],"name":"FeeSetBase","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"fee","type":"uint256"}],"name":"FeeSetCancellation","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256[]","name":"fee","type":"uint256[]"}],"name":"FeeSetCostPerMetre","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"fee","type":"uint256"}],"name":"FeeSetCostPerMinute","type":"event"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"}],"name":"getBaseFee","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"}],"name":"getCancellationFee","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"},{"internalType":"uint256","name":"_badge","type":"uint256"}],"name":"getCostPerMetre","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"}],"name":"getCostPerMinute","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"},{"internalType":"uint256","name":"_badge","type":"uint256"},{"internalType":"uint256","name":"_minutesTaken","type":"uint256"},{"internalType":"uint256","name":"_metresTravelled","type":"uint256"}],"name":"getFare","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"},{"internalType":"uint256","name":"_baseFee","type":"uint256"}],"name":"setBaseFee","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"},{"internalType":"uint256","name":"_cancellationFee","type":"uint256"}],"name":"setCancellationFee","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"},{"internalType":"uint256[]","name":"_costPerMetre","type":"uint256[]"}],"name":"setCostPerMetre","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_key","type":"bytes32"},{"internalType":"uint256","name":"_costPerMinute","type":"uint256"}],"name":"setCostPerMinute","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RideFee');

class RideFee extends _i1.GeneratedContract {
  RideFee(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getBaseFee(_i2.Uint8List _key, {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '9cfd9c4d'));
    final params = [_key];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getCancellationFee(_i2.Uint8List _key,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '422c8372'));
    final params = [_key];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getCostPerMetre(_i2.Uint8List _key, BigInt _badge,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'a4ff372e'));
    final params = [_key, _badge];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getCostPerMinute(_i2.Uint8List _key,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '0359d84e'));
    final params = [_key];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getFare(_i2.Uint8List _key, BigInt _badge,
      BigInt _minutesTaken, BigInt _metresTravelled,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'a1ccafa1'));
    final params = [_key, _badge, _minutesTaken, _metresTravelled];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setBaseFee(_i2.Uint8List _key, BigInt _baseFee,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '8866778f'));
    final params = [_key, _baseFee];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setCancellationFee(_i2.Uint8List _key, BigInt _cancellationFee,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'fb58f06f'));
    final params = [_key, _cancellationFee];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setCostPerMetre(_i2.Uint8List _key, List<BigInt> _costPerMetre,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, 'e881dc31'));
    final params = [_key, _costPerMetre];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setCostPerMinute(_i2.Uint8List _key, BigInt _costPerMinute,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, 'b1e51a68'));
    final params = [_key, _costPerMinute];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all FeeSetBase events emitted by this contract.
  Stream<FeeSetBase> feeSetBaseEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('FeeSetBase');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return FeeSetBase(decoded);
    });
  }

  /// Returns a live stream of all FeeSetCancellation events emitted by this contract.
  Stream<FeeSetCancellation> feeSetCancellationEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('FeeSetCancellation');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return FeeSetCancellation(decoded);
    });
  }

  /// Returns a live stream of all FeeSetCostPerMetre events emitted by this contract.
  Stream<FeeSetCostPerMetre> feeSetCostPerMetreEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('FeeSetCostPerMetre');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return FeeSetCostPerMetre(decoded);
    });
  }

  /// Returns a live stream of all FeeSetCostPerMinute events emitted by this contract.
  Stream<FeeSetCostPerMinute> feeSetCostPerMinuteEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('FeeSetCostPerMinute');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return FeeSetCostPerMinute(decoded);
    });
  }
}

class FeeSetBase {
  FeeSetBase(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        fee = (response[1] as BigInt);

  final _i1.EthereumAddress sender;

  final BigInt fee;
}

class FeeSetCancellation {
  FeeSetCancellation(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        fee = (response[1] as BigInt);

  final _i1.EthereumAddress sender;

  final BigInt fee;
}

class FeeSetCostPerMetre {
  FeeSetCostPerMetre(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        fee = (response[1] as List<dynamic>).cast<BigInt>();

  final _i1.EthereumAddress sender;

  final List<BigInt> fee;
}

class FeeSetCostPerMinute {
  FeeSetCostPerMinute(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        fee = (response[1] as BigInt);

  final _i1.EthereumAddress sender;

  final BigInt fee;
}
