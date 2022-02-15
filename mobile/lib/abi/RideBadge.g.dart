// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sender","type":"address"},{"indexed":false,"internalType":"uint256[]","name":"scores","type":"uint256[]"}],"name":"SetBadgesMaxScores","type":"event"},{"inputs":[{"internalType":"uint256","name":"_badge","type":"uint256"}],"name":"getBadgeToBadgeMaxScore","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_driver","type":"address"}],"name":"getDriverToDriverReputation","outputs":[{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"string","name":"uri","type":"string"},{"internalType":"uint256","name":"maxMetresPerTrip","type":"uint256"},{"internalType":"uint256","name":"metresTravelled","type":"uint256"},{"internalType":"uint256","name":"countStart","type":"uint256"},{"internalType":"uint256","name":"countEnd","type":"uint256"},{"internalType":"uint256","name":"totalRating","type":"uint256"},{"internalType":"uint256","name":"countRating","type":"uint256"}],"internalType":"struct RideLibBadge.DriverReputation","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"_badgesMaxScores","type":"uint256[]"}],"name":"setBadgesMaxScores","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RideBadge');

class RideBadge extends _i1.GeneratedContract {
  RideBadge(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getBadgeToBadgeMaxScore(BigInt _badge,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '34a98f75'));
    final params = [_badge];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> getDriverToDriverReputation(_i1.EthereumAddress _driver,
      {_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '018c3480'));
    final params = [_driver];
    final response = await read(function, params, atBlock);
    return (response[0] as dynamic);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setBadgesMaxScores(List<BigInt> _badgesMaxScores,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '66fac439'));
    final params = [_badgesMaxScores];
    return write(credentials, transaction, function, params);
  }

  /// Returns a live stream of all SetBadgesMaxScores events emitted by this contract.
  Stream<SetBadgesMaxScores> setBadgesMaxScoresEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('SetBadgesMaxScores');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return SetBadgesMaxScores(decoded);
    });
  }
}

class SetBadgesMaxScores {
  SetBadgesMaxScores(List<dynamic> response)
      : sender = (response[0] as _i1.EthereumAddress),
        scores = (response[1] as List<dynamic>).cast<BigInt>();

  final _i1.EthereumAddress sender;

  final List<BigInt> scores;
}
