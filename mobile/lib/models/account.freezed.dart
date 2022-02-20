// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AccountTearOff {
  const _$AccountTearOff();

  _Account call(
      {required bool isOwner,
      required String publicKey,
      @JsonKey(ignore: true) EtherAmount? balance,
      required BigInt wETHBalance,
      required BigInt holdingInFiat,
      required BigInt holdingInCrypto}) {
    return _Account(
      isOwner: isOwner,
      publicKey: publicKey,
      balance: balance,
      wETHBalance: wETHBalance,
      holdingInFiat: holdingInFiat,
      holdingInCrypto: holdingInCrypto,
    );
  }
}

/// @nodoc
const $Account = _$AccountTearOff();

/// @nodoc
mixin _$Account {
  bool get isOwner => throw _privateConstructorUsedError;
  String get publicKey => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  EtherAmount? get balance => throw _privateConstructorUsedError;
  BigInt get wETHBalance => throw _privateConstructorUsedError;
  BigInt get holdingInFiat => throw _privateConstructorUsedError;
  BigInt get holdingInCrypto => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res>;
  $Res call(
      {bool isOwner,
      String publicKey,
      @JsonKey(ignore: true) EtherAmount? balance,
      BigInt wETHBalance,
      BigInt holdingInFiat,
      BigInt holdingInCrypto});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res> implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  final Account _value;
  // ignore: unused_field
  final $Res Function(Account) _then;

  @override
  $Res call({
    Object? isOwner = freezed,
    Object? publicKey = freezed,
    Object? balance = freezed,
    Object? wETHBalance = freezed,
    Object? holdingInFiat = freezed,
    Object? holdingInCrypto = freezed,
  }) {
    return _then(_value.copyWith(
      isOwner: isOwner == freezed
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      publicKey: publicKey == freezed
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      balance: balance == freezed
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as EtherAmount?,
      wETHBalance: wETHBalance == freezed
          ? _value.wETHBalance
          : wETHBalance // ignore: cast_nullable_to_non_nullable
              as BigInt,
      holdingInFiat: holdingInFiat == freezed
          ? _value.holdingInFiat
          : holdingInFiat // ignore: cast_nullable_to_non_nullable
              as BigInt,
      holdingInCrypto: holdingInCrypto == freezed
          ? _value.holdingInCrypto
          : holdingInCrypto // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc
abstract class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) then) =
      __$AccountCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isOwner,
      String publicKey,
      @JsonKey(ignore: true) EtherAmount? balance,
      BigInt wETHBalance,
      BigInt holdingInFiat,
      BigInt holdingInCrypto});
}

/// @nodoc
class __$AccountCopyWithImpl<$Res> extends _$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(_Account _value, $Res Function(_Account) _then)
      : super(_value, (v) => _then(v as _Account));

  @override
  _Account get _value => super._value as _Account;

  @override
  $Res call({
    Object? isOwner = freezed,
    Object? publicKey = freezed,
    Object? balance = freezed,
    Object? wETHBalance = freezed,
    Object? holdingInFiat = freezed,
    Object? holdingInCrypto = freezed,
  }) {
    return _then(_Account(
      isOwner: isOwner == freezed
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      publicKey: publicKey == freezed
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      balance: balance == freezed
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as EtherAmount?,
      wETHBalance: wETHBalance == freezed
          ? _value.wETHBalance
          : wETHBalance // ignore: cast_nullable_to_non_nullable
              as BigInt,
      holdingInFiat: holdingInFiat == freezed
          ? _value.holdingInFiat
          : holdingInFiat // ignore: cast_nullable_to_non_nullable
              as BigInt,
      holdingInCrypto: holdingInCrypto == freezed
          ? _value.holdingInCrypto
          : holdingInCrypto // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$_Account implements _Account {
  const _$_Account(
      {required this.isOwner,
      required this.publicKey,
      @JsonKey(ignore: true) this.balance,
      required this.wETHBalance,
      required this.holdingInFiat,
      required this.holdingInCrypto});

  @override
  final bool isOwner;
  @override
  final String publicKey;
  @override
  @JsonKey(ignore: true)
  final EtherAmount? balance;
  @override
  final BigInt wETHBalance;
  @override
  final BigInt holdingInFiat;
  @override
  final BigInt holdingInCrypto;

  @override
  String toString() {
    return 'Account(isOwner: $isOwner, publicKey: $publicKey, balance: $balance, wETHBalance: $wETHBalance, holdingInFiat: $holdingInFiat, holdingInCrypto: $holdingInCrypto)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Account &&
            const DeepCollectionEquality().equals(other.isOwner, isOwner) &&
            const DeepCollectionEquality().equals(other.publicKey, publicKey) &&
            const DeepCollectionEquality().equals(other.balance, balance) &&
            const DeepCollectionEquality()
                .equals(other.wETHBalance, wETHBalance) &&
            const DeepCollectionEquality()
                .equals(other.holdingInFiat, holdingInFiat) &&
            const DeepCollectionEquality()
                .equals(other.holdingInCrypto, holdingInCrypto));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isOwner),
      const DeepCollectionEquality().hash(publicKey),
      const DeepCollectionEquality().hash(balance),
      const DeepCollectionEquality().hash(wETHBalance),
      const DeepCollectionEquality().hash(holdingInFiat),
      const DeepCollectionEquality().hash(holdingInCrypto));

  @JsonKey(ignore: true)
  @override
  _$AccountCopyWith<_Account> get copyWith =>
      __$AccountCopyWithImpl<_Account>(this, _$identity);
}

abstract class _Account implements Account {
  const factory _Account(
      {required bool isOwner,
      required String publicKey,
      @JsonKey(ignore: true) EtherAmount? balance,
      required BigInt wETHBalance,
      required BigInt holdingInFiat,
      required BigInt holdingInCrypto}) = _$_Account;

  @override
  bool get isOwner;
  @override
  String get publicKey;
  @override
  @JsonKey(ignore: true)
  EtherAmount? get balance;
  @override
  BigInt get wETHBalance;
  @override
  BigInt get holdingInFiat;
  @override
  BigInt get holdingInCrypto;
  @override
  @JsonKey(ignore: true)
  _$AccountCopyWith<_Account> get copyWith =>
      throw _privateConstructorUsedError;
}
