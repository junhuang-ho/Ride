// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'driver.ride.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DriverRideStateTearOff {
  const _$DriverRideStateTearOff();

  _DriverRideError error(String? message) {
    return _DriverRideError(
      message,
    );
  }

  _DriverRideInit init() {
    return const _DriverRideInit();
  }

  _DriverRideAcceptingTicket acceptingTicket() {
    return const _DriverRideAcceptingTicket();
  }

  _DriverRideInTrip inTrip(RideRequest rideRequest) {
    return _DriverRideInTrip(
      rideRequest,
    );
  }
}

/// @nodoc
const $DriverRideState = _$DriverRideStateTearOff();

/// @nodoc
mixin _$DriverRideState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() acceptingTicket,
    required TResult Function(RideRequest rideRequest) inTrip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DriverRideError value) error,
    required TResult Function(_DriverRideInit value) init,
    required TResult Function(_DriverRideAcceptingTicket value) acceptingTicket,
    required TResult Function(_DriverRideInTrip value) inTrip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverRideStateCopyWith<$Res> {
  factory $DriverRideStateCopyWith(
          DriverRideState value, $Res Function(DriverRideState) then) =
      _$DriverRideStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DriverRideStateCopyWithImpl<$Res>
    implements $DriverRideStateCopyWith<$Res> {
  _$DriverRideStateCopyWithImpl(this._value, this._then);

  final DriverRideState _value;
  // ignore: unused_field
  final $Res Function(DriverRideState) _then;
}

/// @nodoc
abstract class _$DriverRideErrorCopyWith<$Res> {
  factory _$DriverRideErrorCopyWith(
          _DriverRideError value, $Res Function(_DriverRideError) then) =
      __$DriverRideErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$DriverRideErrorCopyWithImpl<$Res>
    extends _$DriverRideStateCopyWithImpl<$Res>
    implements _$DriverRideErrorCopyWith<$Res> {
  __$DriverRideErrorCopyWithImpl(
      _DriverRideError _value, $Res Function(_DriverRideError) _then)
      : super(_value, (v) => _then(v as _DriverRideError));

  @override
  _DriverRideError get _value => super._value as _DriverRideError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_DriverRideError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DriverRideError implements _DriverRideError {
  const _$_DriverRideError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'DriverRideState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverRideError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$DriverRideErrorCopyWith<_DriverRideError> get copyWith =>
      __$DriverRideErrorCopyWithImpl<_DriverRideError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() acceptingTicket,
    required TResult Function(RideRequest rideRequest) inTrip,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DriverRideError value) error,
    required TResult Function(_DriverRideInit value) init,
    required TResult Function(_DriverRideAcceptingTicket value) acceptingTicket,
    required TResult Function(_DriverRideInTrip value) inTrip,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _DriverRideError implements DriverRideState {
  const factory _DriverRideError(String? message) = _$_DriverRideError;

  String? get message;
  @JsonKey(ignore: true)
  _$DriverRideErrorCopyWith<_DriverRideError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$DriverRideInitCopyWith<$Res> {
  factory _$DriverRideInitCopyWith(
          _DriverRideInit value, $Res Function(_DriverRideInit) then) =
      __$DriverRideInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$DriverRideInitCopyWithImpl<$Res>
    extends _$DriverRideStateCopyWithImpl<$Res>
    implements _$DriverRideInitCopyWith<$Res> {
  __$DriverRideInitCopyWithImpl(
      _DriverRideInit _value, $Res Function(_DriverRideInit) _then)
      : super(_value, (v) => _then(v as _DriverRideInit));

  @override
  _DriverRideInit get _value => super._value as _DriverRideInit;
}

/// @nodoc

class _$_DriverRideInit implements _DriverRideInit {
  const _$_DriverRideInit();

  @override
  String toString() {
    return 'DriverRideState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DriverRideInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() acceptingTicket,
    required TResult Function(RideRequest rideRequest) inTrip,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DriverRideError value) error,
    required TResult Function(_DriverRideInit value) init,
    required TResult Function(_DriverRideAcceptingTicket value) acceptingTicket,
    required TResult Function(_DriverRideInTrip value) inTrip,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _DriverRideInit implements DriverRideState {
  const factory _DriverRideInit() = _$_DriverRideInit;
}

/// @nodoc
abstract class _$DriverRideAcceptingTicketCopyWith<$Res> {
  factory _$DriverRideAcceptingTicketCopyWith(_DriverRideAcceptingTicket value,
          $Res Function(_DriverRideAcceptingTicket) then) =
      __$DriverRideAcceptingTicketCopyWithImpl<$Res>;
}

/// @nodoc
class __$DriverRideAcceptingTicketCopyWithImpl<$Res>
    extends _$DriverRideStateCopyWithImpl<$Res>
    implements _$DriverRideAcceptingTicketCopyWith<$Res> {
  __$DriverRideAcceptingTicketCopyWithImpl(_DriverRideAcceptingTicket _value,
      $Res Function(_DriverRideAcceptingTicket) _then)
      : super(_value, (v) => _then(v as _DriverRideAcceptingTicket));

  @override
  _DriverRideAcceptingTicket get _value =>
      super._value as _DriverRideAcceptingTicket;
}

/// @nodoc

class _$_DriverRideAcceptingTicket implements _DriverRideAcceptingTicket {
  const _$_DriverRideAcceptingTicket();

  @override
  String toString() {
    return 'DriverRideState.acceptingTicket()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverRideAcceptingTicket);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() acceptingTicket,
    required TResult Function(RideRequest rideRequest) inTrip,
  }) {
    return acceptingTicket();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
  }) {
    return acceptingTicket?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
    required TResult orElse(),
  }) {
    if (acceptingTicket != null) {
      return acceptingTicket();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DriverRideError value) error,
    required TResult Function(_DriverRideInit value) init,
    required TResult Function(_DriverRideAcceptingTicket value) acceptingTicket,
    required TResult Function(_DriverRideInTrip value) inTrip,
  }) {
    return acceptingTicket(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
  }) {
    return acceptingTicket?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
    required TResult orElse(),
  }) {
    if (acceptingTicket != null) {
      return acceptingTicket(this);
    }
    return orElse();
  }
}

abstract class _DriverRideAcceptingTicket implements DriverRideState {
  const factory _DriverRideAcceptingTicket() = _$_DriverRideAcceptingTicket;
}

/// @nodoc
abstract class _$DriverRideInTripCopyWith<$Res> {
  factory _$DriverRideInTripCopyWith(
          _DriverRideInTrip value, $Res Function(_DriverRideInTrip) then) =
      __$DriverRideInTripCopyWithImpl<$Res>;
  $Res call({RideRequest rideRequest});
}

/// @nodoc
class __$DriverRideInTripCopyWithImpl<$Res>
    extends _$DriverRideStateCopyWithImpl<$Res>
    implements _$DriverRideInTripCopyWith<$Res> {
  __$DriverRideInTripCopyWithImpl(
      _DriverRideInTrip _value, $Res Function(_DriverRideInTrip) _then)
      : super(_value, (v) => _then(v as _DriverRideInTrip));

  @override
  _DriverRideInTrip get _value => super._value as _DriverRideInTrip;

  @override
  $Res call({
    Object? rideRequest = freezed,
  }) {
    return _then(_DriverRideInTrip(
      rideRequest == freezed
          ? _value.rideRequest
          : rideRequest // ignore: cast_nullable_to_non_nullable
              as RideRequest,
    ));
  }
}

/// @nodoc

class _$_DriverRideInTrip implements _DriverRideInTrip {
  const _$_DriverRideInTrip(this.rideRequest);

  @override
  final RideRequest rideRequest;

  @override
  String toString() {
    return 'DriverRideState.inTrip(rideRequest: $rideRequest)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverRideInTrip &&
            const DeepCollectionEquality()
                .equals(other.rideRequest, rideRequest));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(rideRequest));

  @JsonKey(ignore: true)
  @override
  _$DriverRideInTripCopyWith<_DriverRideInTrip> get copyWith =>
      __$DriverRideInTripCopyWithImpl<_DriverRideInTrip>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() acceptingTicket,
    required TResult Function(RideRequest rideRequest) inTrip,
  }) {
    return inTrip(rideRequest);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
  }) {
    return inTrip?.call(rideRequest);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? acceptingTicket,
    TResult Function(RideRequest rideRequest)? inTrip,
    required TResult orElse(),
  }) {
    if (inTrip != null) {
      return inTrip(rideRequest);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DriverRideError value) error,
    required TResult Function(_DriverRideInit value) init,
    required TResult Function(_DriverRideAcceptingTicket value) acceptingTicket,
    required TResult Function(_DriverRideInTrip value) inTrip,
  }) {
    return inTrip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
  }) {
    return inTrip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverRideError value)? error,
    TResult Function(_DriverRideInit value)? init,
    TResult Function(_DriverRideAcceptingTicket value)? acceptingTicket,
    TResult Function(_DriverRideInTrip value)? inTrip,
    required TResult orElse(),
  }) {
    if (inTrip != null) {
      return inTrip(this);
    }
    return orElse();
  }
}

abstract class _DriverRideInTrip implements DriverRideState {
  const factory _DriverRideInTrip(RideRequest rideRequest) =
      _$_DriverRideInTrip;

  RideRequest get rideRequest;
  @JsonKey(ignore: true)
  _$DriverRideInTripCopyWith<_DriverRideInTrip> get copyWith =>
      throw _privateConstructorUsedError;
}
