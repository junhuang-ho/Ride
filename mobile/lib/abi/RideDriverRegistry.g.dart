// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"applicant","type":"address"}],"name":"ApplicantApproved","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256","name":"metres","type":"uint256"}],"name":"MaxMetresUpdated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"}],"name":"RegisteredAsDriver","type":"event"},{"inputs":[{"internalType":"address","name":"_driver","type":"address"},{"internalType":"string","name":"_uri","type":"string"}],"name":"approveApplicant","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_maxMetresPerTrip","type":"uint256"}],"name":"registerAsDriver","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_maxMetresPerTrip","type":"uint256"}],"name":"updateMaxMetresPerTrip","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RideDriverRegistry');

class RideDriverRegistry extends _i1.GeneratedContract {
  RideDriverRegistry(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> approveApplicant(_i1.EthereumAddress _driver, String _uri,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '72c23df2'));
    final params = [_driver, _uri];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> registerAsDriver(BigInt _maxMetresPerTrip,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '8d5f5e0c'));
    final params = [_maxMetresPerTrip];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> updateMaxMetresPerTrip(BigInt _maxMetresPerTrip,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'eacd7883'));
    final params = [_maxMetresPerTrip];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all ApplicantApproved events emitted by this contract.
  Stream<ApplicantApproved> applicantApprovedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('ApplicantApproved');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return ApplicantApproved(decoded);
    });
  }

  /// Returns a live stream of all MaxMetresUpdated events emitted by this contract.
  Stream<MaxMetresUpdated> maxMetresUpdatedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('MaxMetresUpdated');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return MaxMetresUpdated(decoded);
    });
  }

  /// Returns a live stream of all RegisteredAsDriver events emitted by this contract.
  Stream<RegisteredAsDriver> registeredAsDriverEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('RegisteredAsDriver');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return RegisteredAsDriver(decoded);
    });
  }
}

class ApplicantApproved {
  ApplicantApproved(List<dynamic> response)
      : applicant = (response[0] as _i1.EthereumAddress);

  final _i1.EthereumAddress applicant;
}

class MaxMetresUpdated {
  MaxMetresUpdated(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        metres = (response[1] as BigInt);

  final _i1.EthereumAddress sender;

  final BigInt metres;
}

class RegisteredAsDriver {
  RegisteredAsDriver(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress);

  final _i1.EthereumAddress sender;
}
