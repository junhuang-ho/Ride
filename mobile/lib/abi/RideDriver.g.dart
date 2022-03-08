// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"}],"name":"AcceptedTicket","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"}],"name":"DriverCancelled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"}],"name":"ForceEndDrv","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"},{"indexed":false,"internalType":"bool","name":"reached","type":"bool"}],"name":"TripEndedDrv","type":"event"},{"inputs":[{"internalType":"bytes32","name":"_keyLocal","type":"bytes32"},{"internalType":"bytes32","name":"_keyAccept","type":"bytes32"},{"internalType":"bytes32","name":"_tixId","type":"bytes32"},{"internalType":"uint256","name":"_useBadge","type":"uint256"}],"name":"acceptTicket","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"cancelPickUp","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bool","name":"_reached","type":"bool"}],"name":"endTripDrv","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"forceEndDrv","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RideDriver');

class RideDriver extends _i1.GeneratedContract {
  RideDriver(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> acceptTicket(_i2.Uint8List _keyLocal, _i2.Uint8List _keyAccept,
      _i2.Uint8List _tixId, BigInt _useBadge,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '86ad7dd2'));
    final params = [_keyLocal, _keyAccept, _tixId, _useBadge];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> cancelPickUp(
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '16faab27'));
    final params = [];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> endTripDrv(bool _reached,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '650b2730'));
    final params = [_reached];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> forceEndDrv(
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '0e63bee1'));
    final params = [];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all AcceptedTicket events emitted by this contract.
  Stream<AcceptedTicket> acceptedTicketEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('AcceptedTicket');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return AcceptedTicket(decoded);
    });
  }

  /// Returns a live stream of all DriverCancelled events emitted by this contract.
  Stream<DriverCancelled> driverCancelledEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('DriverCancelled');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return DriverCancelled(decoded);
    });
  }

  /// Returns a live stream of all ForceEndDrv events emitted by this contract.
  Stream<ForceEndDrv> forceEndDrvEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('ForceEndDrv');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return ForceEndDrv(decoded);
    });
  }

  /// Returns a live stream of all TripEndedDrv events emitted by this contract.
  Stream<TripEndedDrv> tripEndedDrvEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TripEndedDrv');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TripEndedDrv(decoded);
    });
  }
}

class AcceptedTicket {
  AcceptedTicket(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;
}

class DriverCancelled {
  DriverCancelled(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;
}

class ForceEndDrv {
  ForceEndDrv(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;
}

class TripEndedDrv {
  TripEndedDrv(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List),
        reached = (response[2] as bool);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;

  final bool reached;
}
