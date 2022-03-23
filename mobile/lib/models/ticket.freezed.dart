// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ticket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TicketTearOff {
  const _$TicketTearOff();

  _Ticket call(
      {required EthereumAddress passenger,
      required EthereumAddress driver,
      required BigInt badge,
      required bool strict,
      required BigInt metres,
      required Uint8List keyLocal,
      required Uint8List keyPay,
      required BigInt cancellationFee,
      required BigInt fare,
      required bool tripStart,
      required BigInt forceEndTimestamp}) {
    return _Ticket(
      passenger: passenger,
      driver: driver,
      badge: badge,
      strict: strict,
      metres: metres,
      keyLocal: keyLocal,
      keyPay: keyPay,
      cancellationFee: cancellationFee,
      fare: fare,
      tripStart: tripStart,
      forceEndTimestamp: forceEndTimestamp,
    );
  }
}

/// @nodoc
const $Ticket = _$TicketTearOff();

/// @nodoc
mixin _$Ticket {
  EthereumAddress get passenger => throw _privateConstructorUsedError;
  EthereumAddress get driver => throw _privateConstructorUsedError;
  BigInt get badge => throw _privateConstructorUsedError;
  bool get strict => throw _privateConstructorUsedError;
  BigInt get metres => throw _privateConstructorUsedError;
  Uint8List get keyLocal => throw _privateConstructorUsedError;
  Uint8List get keyPay => throw _privateConstructorUsedError;
  BigInt get cancellationFee => throw _privateConstructorUsedError;
  BigInt get fare => throw _privateConstructorUsedError;
  bool get tripStart => throw _privateConstructorUsedError;
  BigInt get forceEndTimestamp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TicketCopyWith<Ticket> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCopyWith<$Res> {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) then) =
      _$TicketCopyWithImpl<$Res>;
  $Res call(
      {EthereumAddress passenger,
      EthereumAddress driver,
      BigInt badge,
      bool strict,
      BigInt metres,
      Uint8List keyLocal,
      Uint8List keyPay,
      BigInt cancellationFee,
      BigInt fare,
      bool tripStart,
      BigInt forceEndTimestamp});
}

/// @nodoc
class _$TicketCopyWithImpl<$Res> implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._value, this._then);

  final Ticket _value;
  // ignore: unused_field
  final $Res Function(Ticket) _then;

  @override
  $Res call({
    Object? passenger = freezed,
    Object? driver = freezed,
    Object? badge = freezed,
    Object? strict = freezed,
    Object? metres = freezed,
    Object? keyLocal = freezed,
    Object? keyPay = freezed,
    Object? cancellationFee = freezed,
    Object? fare = freezed,
    Object? tripStart = freezed,
    Object? forceEndTimestamp = freezed,
  }) {
    return _then(_value.copyWith(
      passenger: passenger == freezed
          ? _value.passenger
          : passenger // ignore: cast_nullable_to_non_nullable
              as EthereumAddress,
      driver: driver == freezed
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as EthereumAddress,
      badge: badge == freezed
          ? _value.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as BigInt,
      strict: strict == freezed
          ? _value.strict
          : strict // ignore: cast_nullable_to_non_nullable
              as bool,
      metres: metres == freezed
          ? _value.metres
          : metres // ignore: cast_nullable_to_non_nullable
              as BigInt,
      keyLocal: keyLocal == freezed
          ? _value.keyLocal
          : keyLocal // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      keyPay: keyPay == freezed
          ? _value.keyPay
          : keyPay // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      cancellationFee: cancellationFee == freezed
          ? _value.cancellationFee
          : cancellationFee // ignore: cast_nullable_to_non_nullable
              as BigInt,
      fare: fare == freezed
          ? _value.fare
          : fare // ignore: cast_nullable_to_non_nullable
              as BigInt,
      tripStart: tripStart == freezed
          ? _value.tripStart
          : tripStart // ignore: cast_nullable_to_non_nullable
              as bool,
      forceEndTimestamp: forceEndTimestamp == freezed
          ? _value.forceEndTimestamp
          : forceEndTimestamp // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc
abstract class _$TicketCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$TicketCopyWith(_Ticket value, $Res Function(_Ticket) then) =
      __$TicketCopyWithImpl<$Res>;
  @override
  $Res call(
      {EthereumAddress passenger,
      EthereumAddress driver,
      BigInt badge,
      bool strict,
      BigInt metres,
      Uint8List keyLocal,
      Uint8List keyPay,
      BigInt cancellationFee,
      BigInt fare,
      bool tripStart,
      BigInt forceEndTimestamp});
}

/// @nodoc
class __$TicketCopyWithImpl<$Res> extends _$TicketCopyWithImpl<$Res>
    implements _$TicketCopyWith<$Res> {
  __$TicketCopyWithImpl(_Ticket _value, $Res Function(_Ticket) _then)
      : super(_value, (v) => _then(v as _Ticket));

  @override
  _Ticket get _value => super._value as _Ticket;

  @override
  $Res call({
    Object? passenger = freezed,
    Object? driver = freezed,
    Object? badge = freezed,
    Object? strict = freezed,
    Object? metres = freezed,
    Object? keyLocal = freezed,
    Object? keyPay = freezed,
    Object? cancellationFee = freezed,
    Object? fare = freezed,
    Object? tripStart = freezed,
    Object? forceEndTimestamp = freezed,
  }) {
    return _then(_Ticket(
      passenger: passenger == freezed
          ? _value.passenger
          : passenger // ignore: cast_nullable_to_non_nullable
              as EthereumAddress,
      driver: driver == freezed
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as EthereumAddress,
      badge: badge == freezed
          ? _value.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as BigInt,
      strict: strict == freezed
          ? _value.strict
          : strict // ignore: cast_nullable_to_non_nullable
              as bool,
      metres: metres == freezed
          ? _value.metres
          : metres // ignore: cast_nullable_to_non_nullable
              as BigInt,
      keyLocal: keyLocal == freezed
          ? _value.keyLocal
          : keyLocal // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      keyPay: keyPay == freezed
          ? _value.keyPay
          : keyPay // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      cancellationFee: cancellationFee == freezed
          ? _value.cancellationFee
          : cancellationFee // ignore: cast_nullable_to_non_nullable
              as BigInt,
      fare: fare == freezed
          ? _value.fare
          : fare // ignore: cast_nullable_to_non_nullable
              as BigInt,
      tripStart: tripStart == freezed
          ? _value.tripStart
          : tripStart // ignore: cast_nullable_to_non_nullable
              as bool,
      forceEndTimestamp: forceEndTimestamp == freezed
          ? _value.forceEndTimestamp
          : forceEndTimestamp // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$_Ticket implements _Ticket {
  const _$_Ticket(
      {required this.passenger,
      required this.driver,
      required this.badge,
      required this.strict,
      required this.metres,
      required this.keyLocal,
      required this.keyPay,
      required this.cancellationFee,
      required this.fare,
      required this.tripStart,
      required this.forceEndTimestamp});

  @override
  final EthereumAddress passenger;
  @override
  final EthereumAddress driver;
  @override
  final BigInt badge;
  @override
  final bool strict;
  @override
  final BigInt metres;
  @override
  final Uint8List keyLocal;
  @override
  final Uint8List keyPay;
  @override
  final BigInt cancellationFee;
  @override
  final BigInt fare;
  @override
  final bool tripStart;
  @override
  final BigInt forceEndTimestamp;

  @override
  String toString() {
    return 'Ticket(passenger: $passenger, driver: $driver, badge: $badge, strict: $strict, metres: $metres, keyLocal: $keyLocal, keyPay: $keyPay, cancellationFee: $cancellationFee, fare: $fare, tripStart: $tripStart, forceEndTimestamp: $forceEndTimestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Ticket &&
            const DeepCollectionEquality().equals(other.passenger, passenger) &&
            const DeepCollectionEquality().equals(other.driver, driver) &&
            const DeepCollectionEquality().equals(other.badge, badge) &&
            const DeepCollectionEquality().equals(other.strict, strict) &&
            const DeepCollectionEquality().equals(other.metres, metres) &&
            const DeepCollectionEquality().equals(other.keyLocal, keyLocal) &&
            const DeepCollectionEquality().equals(other.keyPay, keyPay) &&
            const DeepCollectionEquality()
                .equals(other.cancellationFee, cancellationFee) &&
            const DeepCollectionEquality().equals(other.fare, fare) &&
            const DeepCollectionEquality().equals(other.tripStart, tripStart) &&
            const DeepCollectionEquality()
                .equals(other.forceEndTimestamp, forceEndTimestamp));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(passenger),
      const DeepCollectionEquality().hash(driver),
      const DeepCollectionEquality().hash(badge),
      const DeepCollectionEquality().hash(strict),
      const DeepCollectionEquality().hash(metres),
      const DeepCollectionEquality().hash(keyLocal),
      const DeepCollectionEquality().hash(keyPay),
      const DeepCollectionEquality().hash(cancellationFee),
      const DeepCollectionEquality().hash(fare),
      const DeepCollectionEquality().hash(tripStart),
      const DeepCollectionEquality().hash(forceEndTimestamp));

  @JsonKey(ignore: true)
  @override
  _$TicketCopyWith<_Ticket> get copyWith =>
      __$TicketCopyWithImpl<_Ticket>(this, _$identity);
}

abstract class _Ticket implements Ticket {
  const factory _Ticket(
      {required EthereumAddress passenger,
      required EthereumAddress driver,
      required BigInt badge,
      required bool strict,
      required BigInt metres,
      required Uint8List keyLocal,
      required Uint8List keyPay,
      required BigInt cancellationFee,
      required BigInt fare,
      required bool tripStart,
      required BigInt forceEndTimestamp}) = _$_Ticket;

  @override
  EthereumAddress get passenger;
  @override
  EthereumAddress get driver;
  @override
  BigInt get badge;
  @override
  bool get strict;
  @override
  BigInt get metres;
  @override
  Uint8List get keyLocal;
  @override
  Uint8List get keyPay;
  @override
  BigInt get cancellationFee;
  @override
  BigInt get fare;
  @override
  bool get tripStart;
  @override
  BigInt get forceEndTimestamp;
  @override
  @JsonKey(ignore: true)
  _$TicketCopyWith<_Ticket> get copyWith => throw _privateConstructorUsedError;
}
