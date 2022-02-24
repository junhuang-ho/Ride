import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

enum AccountType { driver, passenger, admin }

@freezed
class Account with _$Account {
  const factory Account({
    required final AccountType accountType,
    required final String publicKey,
  }) = _Account;
}
