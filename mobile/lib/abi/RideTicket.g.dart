// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"newDelayPeriod","type":"uint256"}],"name":"ForceEndDelaySet","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":true,"internalType":"bytes32","name":"tixId","type":"bytes32"}],"name":"TicketCleared","type":"event"},{"inputs":[{"internalType":"bytes32","name":"_tixId","type":"bytes32"}],"name":"getTixIdToTicket","outputs":[{"components":[{"internalType":"address","name":"passenger","type":"address"},{"internalType":"address","name":"driver","type":"address"},{"internalType":"uint256","name":"badge","type":"uint256"},{"internalType":"bool","name":"strict","type":"bool"},{"internalType":"uint256","name":"metres","type":"uint256"},{"internalType":"bytes32","name":"keyLocal","type":"bytes32"},{"internalType":"bytes32","name":"keyPay","type":"bytes32"},{"internalType":"uint256","name":"cancellationFee","type":"uint256"},{"internalType":"uint256","name":"fare","type":"uint256"},{"internalType":"bool","name":"tripStart","type":"bool"},{"internalType":"uint256","name":"forceEndTimestamp","type":"uint256"}],"internalType":"struct RideLibTicket.Ticket","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_tixId","type":"bytes32"}],"name":"getTixToDriverEnd","outputs":[{"components":[{"internalType":"address","name":"driver","type":"address"},{"internalType":"bool","name":"reached","type":"bool"}],"internalType":"struct RideLibTicket.DriverEnd","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_user","type":"address"}],"name":"getUserToTixId","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_delayPeriod","type":"uint256"}],"name":"setForceEndDelay","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RideTicket');

class RideTicket extends _i1.GeneratedContract {
  RideTicket(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> getTixIdToTicket(_i2.Uint8List _tixId,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '5c4a9eec'));
    final params = [_tixId];
    final response = await read(function, params, atBlock);
    return (response[0] as dynamic);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> getTixToDriverEnd(_i2.Uint8List _tixId,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '72befad2'));
    final params = [_tixId];
    final response = await read(function, params, atBlock);
    return (response[0] as dynamic);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> getUserToTixId(_i1.EthereumAddress _user,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'da31495e'));
    final params = [_user];
    final response = await read(function, params, atBlock);
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setForceEndDelay(BigInt _delayPeriod,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'f802c7c6'));
    final params = [_delayPeriod];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all ForceEndDelaySet events emitted by this contract.
  Stream<ForceEndDelaySet> forceEndDelaySetEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('ForceEndDelaySet');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return ForceEndDelaySet(decoded);
    });
  }

  /// Returns a live stream of all TicketCleared events emitted by this contract.
  Stream<TicketCleared> ticketClearedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TicketCleared');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TicketCleared(decoded);
    });
  }
}

class ForceEndDelaySet {
  ForceEndDelaySet(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        newDelayPeriod = (response[1] as BigInt);

  final _i1.EthereumAddress sender;

  final BigInt newDelayPeriod;
}

class TicketCleared {
  TicketCleared(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        tixId = (response[1] as _i2.Uint8List);

  final _i1.EthereumAddress sender;

  final _i2.Uint8List tixId;
}
