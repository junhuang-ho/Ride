// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"}],"name":"ForceEndPax","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"}],"name":"RequestCancelled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"},{"indexed":false,"internalType":"uint256","name":"fare","type":"uint256"}],"name":"RequestTicket","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"}],"name":"TripEndedPax","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"passenger","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"},{"indexed":false,"internalType":"address","name":"driver","type":"address"}],"name":"TripStarted","type":"event"},{"inputs":[],"name":"cancelRequest","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bool","name":"_agree","type":"bool"},{"internalType":"uint256","name":"_rating","type":"uint256"}],"name":"endTripPax","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"forceEndPax","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_keyLocal","type":"bytes32"},{"internalType":"bytes32","name":"_keyPay","type":"bytes32"},{"internalType":"uint256","name":"_badge","type":"uint256"},{"internalType":"bool","name":"_strict","type":"bool"},{"internalType":"uint256","name":"_metres","type":"uint256"},{"internalType":"uint256","name":"_minutes","type":"uint256"}],"name":"requestTicket","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_driver","type":"address"}],"name":"startTrip","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RidePassenger');

class RidePassenger extends _i1.GeneratedContract {
  RidePassenger(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> cancelRequest(
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '851b16f5'));
    final params = [];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> endTripPax(bool _agree, BigInt _rating,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'cc2c19b3'));
    final params = [_agree, _rating];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> forceEndPax(
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '8bf60809'));
    final params = [];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> requestTicket(_i2.Uint8List _keyLocal, _i2.Uint8List _keyPay,
      BigInt _badge, bool _strict, BigInt _metres, BigInt _minutes,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'e5964c8a'));
    final params = [_keyLocal, _keyPay, _badge, _strict, _metres, _minutes];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> startTrip(_i1.EthereumAddress _driver,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '4e20be16'));
    final params = [_driver];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all ForceEndPax events emitted by this contract.
  Stream<ForceEndPax> forceEndPaxEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('ForceEndPax');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return ForceEndPax(decoded);
    });
  }

  /// Returns a live stream of all RequestCancelled events emitted by this contract.
  Stream<RequestCancelled> requestCancelledEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('RequestCancelled');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return RequestCancelled(decoded);
    });
  }

  /// Returns a live stream of all RequestTicket events emitted by this contract.
  Stream<RequestTicket> requestTicketEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('RequestTicket');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return RequestTicket(decoded);
    });
  }

  /// Returns a live stream of all TripEndedPax events emitted by this contract.
  Stream<TripEndedPax> tripEndedPaxEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TripEndedPax');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TripEndedPax(decoded);
    });
  }

  /// Returns a live stream of all TripStarted events emitted by this contract.
  Stream<TripStarted> tripStartedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TripStarted');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TripStarted(decoded);
    });
  }
}

class ForceEndPax {
  ForceEndPax(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;
}

class RequestCancelled {
  RequestCancelled(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;
}

class RequestTicket {
  RequestTicket(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List),
        fare = (response[2] as BigInt);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;

  final BigInt fare;
}

class TripEndedPax {
  TripEndedPax(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;
}

class TripStarted {
  TripStarted(List<dynamic> response)
      : passenger = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List),
        driver = (response[2] as _i1.EthereumAddress);

  final _i1.EthereumAddress passenger;

  final _i2.Uint8List tixId;

  final _i1.EthereumAddress driver;
}
