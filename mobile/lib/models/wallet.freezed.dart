// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$WalletTearOff {
  const _$WalletTearOff();

  _Wallet call(
      {@JsonKey(ignore: true) EtherAmount? balance,
      required BigInt wETHBalance,
      required BigInt holdingInCrypto}) {
    return _Wallet(
      balance: balance,
      wETHBalance: wETHBalance,
      holdingInCrypto: holdingInCrypto,
    );
  }
}

/// @nodoc
const $Wallet = _$WalletTearOff();

/// @nodoc
mixin _$Wallet {
// ignore: invalid_annotation_target
  @JsonKey(ignore: true)
  EtherAmount? get balance => throw _privateConstructorUsedError;
  BigInt get wETHBalance => throw _privateConstructorUsedError;
  BigInt get holdingInCrypto => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WalletCopyWith<Wallet> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletCopyWith<$Res> {
  factory $WalletCopyWith(Wallet value, $Res Function(Wallet) then) =
      _$WalletCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(ignore: true) EtherAmount? balance,
      BigInt wETHBalance,
      BigInt holdingInCrypto});
}

/// @nodoc
class _$WalletCopyWithImpl<$Res> implements $WalletCopyWith<$Res> {
  _$WalletCopyWithImpl(this._value, this._then);

  final Wallet _value;
  // ignore: unused_field
  final $Res Function(Wallet) _then;

  @override
  $Res call({
    Object? balance = freezed,
    Object? wETHBalance = freezed,
    Object? holdingInCrypto = freezed,
  }) {
    return _then(_value.copyWith(
      balance: balance == freezed
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as EtherAmount?,
      wETHBalance: wETHBalance == freezed
          ? _value.wETHBalance
          : wETHBalance // ignore: cast_nullable_to_non_nullable
              as BigInt,
      holdingInCrypto: holdingInCrypto == freezed
          ? _value.holdingInCrypto
          : holdingInCrypto // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc
abstract class _$WalletCopyWith<$Res> implements $WalletCopyWith<$Res> {
  factory _$WalletCopyWith(_Wallet value, $Res Function(_Wallet) then) =
      __$WalletCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(ignore: true) EtherAmount? balance,
      BigInt wETHBalance,
      BigInt holdingInCrypto});
}

/// @nodoc
class __$WalletCopyWithImpl<$Res> extends _$WalletCopyWithImpl<$Res>
    implements _$WalletCopyWith<$Res> {
  __$WalletCopyWithImpl(_Wallet _value, $Res Function(_Wallet) _then)
      : super(_value, (v) => _then(v as _Wallet));

  @override
  _Wallet get _value => super._value as _Wallet;

  @override
  $Res call({
    Object? balance = freezed,
    Object? wETHBalance = freezed,
    Object? holdingInCrypto = freezed,
  }) {
    return _then(_Wallet(
      balance: balance == freezed
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as EtherAmount?,
      wETHBalance: wETHBalance == freezed
          ? _value.wETHBalance
          : wETHBalance // ignore: cast_nullable_to_non_nullable
              as BigInt,
      holdingInCrypto: holdingInCrypto == freezed
          ? _value.holdingInCrypto
          : holdingInCrypto // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$_Wallet implements _Wallet {
  const _$_Wallet(
      {@JsonKey(ignore: true) this.balance,
      required this.wETHBalance,
      required this.holdingInCrypto});

  @override // ignore: invalid_annotation_target
  @JsonKey(ignore: true)
  final EtherAmount? balance;
  @override
  final BigInt wETHBalance;
  @override
  final BigInt holdingInCrypto;

  @override
  String toString() {
    return 'Wallet(balance: $balance, wETHBalance: $wETHBalance, holdingInCrypto: $holdingInCrypto)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Wallet &&
            const DeepCollectionEquality().equals(other.balance, balance) &&
            const DeepCollectionEquality()
                .equals(other.wETHBalance, wETHBalance) &&
            const DeepCollectionEquality()
                .equals(other.holdingInCrypto, holdingInCrypto));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(balance),
      const DeepCollectionEquality().hash(wETHBalance),
      const DeepCollectionEquality().hash(holdingInCrypto));

  @JsonKey(ignore: true)
  @override
  _$WalletCopyWith<_Wallet> get copyWith =>
      __$WalletCopyWithImpl<_Wallet>(this, _$identity);
}

abstract class _Wallet implements Wallet {
  const factory _Wallet(
      {@JsonKey(ignore: true) EtherAmount? balance,
      required BigInt wETHBalance,
      required BigInt holdingInCrypto}) = _$_Wallet;

  @override // ignore: invalid_annotation_target
  @JsonKey(ignore: true)
  EtherAmount? get balance;
  @override
  BigInt get wETHBalance;
  @override
  BigInt get holdingInCrypto;
  @override
  @JsonKey(ignore: true)
  _$WalletCopyWith<_Wallet> get copyWith => throw _privateConstructorUsedError;
}
