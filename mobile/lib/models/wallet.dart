import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet.freezed.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    // ignore: invalid_annotation_target
    @JsonKey(ignore: true) EtherAmount? balance,
    required final BigInt wETHBalance,
    required final BigInt holdingInCrypto,
  }) = _Wallet;
}
