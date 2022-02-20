import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required final bool isOwner,
    required final String publicKey,
    @JsonKey(ignore: true) EtherAmount? balance,
    required final BigInt wETHBalance,
    required final BigInt holdingInFiat,
    required final BigInt holdingInCrypto,
  }) = _Account;
}
