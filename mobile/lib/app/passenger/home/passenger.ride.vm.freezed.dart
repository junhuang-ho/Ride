// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'passenger.ride.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PassengerRideStateTearOff {
  const _$PassengerRideStateTearOff();

  _PassengerRideError error(String? message) {
    return _PassengerRideError(
      message,
    );
  }

  _PassengerRideInit init() {
    return const _PassengerRideInit();
  }

  _PassengerRideDirection direction(DirectionDetails directionDetails) {
    return _PassengerRideDirection(
      directionDetails,
    );
  }

  _PassengerRideRequesting requesting(String tixId) {
    return _PassengerRideRequesting(
      tixId,
    );
  }
}

/// @nodoc
const $PassengerRideState = _$PassengerRideStateTearOff();

/// @nodoc
mixin _$PassengerRideState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function(DirectionDetails directionDetails) direction,
    required TResult Function(String tixId) requesting,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerRideError value) error,
    required TResult Function(_PassengerRideInit value) init,
    required TResult Function(_PassengerRideDirection value) direction,
    required TResult Function(_PassengerRideRequesting value) requesting,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassengerRideStateCopyWith<$Res> {
  factory $PassengerRideStateCopyWith(
          PassengerRideState value, $Res Function(PassengerRideState) then) =
      _$PassengerRideStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$PassengerRideStateCopyWithImpl<$Res>
    implements $PassengerRideStateCopyWith<$Res> {
  _$PassengerRideStateCopyWithImpl(this._value, this._then);

  final PassengerRideState _value;
  // ignore: unused_field
  final $Res Function(PassengerRideState) _then;
}

/// @nodoc
abstract class _$PassengerRideErrorCopyWith<$Res> {
  factory _$PassengerRideErrorCopyWith(
          _PassengerRideError value, $Res Function(_PassengerRideError) then) =
      __$PassengerRideErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$PassengerRideErrorCopyWithImpl<$Res>
    extends _$PassengerRideStateCopyWithImpl<$Res>
    implements _$PassengerRideErrorCopyWith<$Res> {
  __$PassengerRideErrorCopyWithImpl(
      _PassengerRideError _value, $Res Function(_PassengerRideError) _then)
      : super(_value, (v) => _then(v as _PassengerRideError));

  @override
  _PassengerRideError get _value => super._value as _PassengerRideError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_PassengerRideError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_PassengerRideError implements _PassengerRideError {
  const _$_PassengerRideError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'PassengerRideState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerRideError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$PassengerRideErrorCopyWith<_PassengerRideError> get copyWith =>
      __$PassengerRideErrorCopyWithImpl<_PassengerRideError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function(DirectionDetails directionDetails) direction,
    required TResult Function(String tixId) requesting,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
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
    required TResult Function(_PassengerRideError value) error,
    required TResult Function(_PassengerRideInit value) init,
    required TResult Function(_PassengerRideDirection value) direction,
    required TResult Function(_PassengerRideRequesting value) requesting,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _PassengerRideError implements PassengerRideState {
  const factory _PassengerRideError(String? message) = _$_PassengerRideError;

  String? get message;
  @JsonKey(ignore: true)
  _$PassengerRideErrorCopyWith<_PassengerRideError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$PassengerRideInitCopyWith<$Res> {
  factory _$PassengerRideInitCopyWith(
          _PassengerRideInit value, $Res Function(_PassengerRideInit) then) =
      __$PassengerRideInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$PassengerRideInitCopyWithImpl<$Res>
    extends _$PassengerRideStateCopyWithImpl<$Res>
    implements _$PassengerRideInitCopyWith<$Res> {
  __$PassengerRideInitCopyWithImpl(
      _PassengerRideInit _value, $Res Function(_PassengerRideInit) _then)
      : super(_value, (v) => _then(v as _PassengerRideInit));

  @override
  _PassengerRideInit get _value => super._value as _PassengerRideInit;
}

/// @nodoc

class _$_PassengerRideInit implements _PassengerRideInit {
  const _$_PassengerRideInit();

  @override
  String toString() {
    return 'PassengerRideState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _PassengerRideInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function(DirectionDetails directionDetails) direction,
    required TResult Function(String tixId) requesting,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
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
    required TResult Function(_PassengerRideError value) error,
    required TResult Function(_PassengerRideInit value) init,
    required TResult Function(_PassengerRideDirection value) direction,
    required TResult Function(_PassengerRideRequesting value) requesting,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _PassengerRideInit implements PassengerRideState {
  const factory _PassengerRideInit() = _$_PassengerRideInit;
}

/// @nodoc
abstract class _$PassengerRideDirectionCopyWith<$Res> {
  factory _$PassengerRideDirectionCopyWith(_PassengerRideDirection value,
          $Res Function(_PassengerRideDirection) then) =
      __$PassengerRideDirectionCopyWithImpl<$Res>;
  $Res call({DirectionDetails directionDetails});

  $DirectionDetailsCopyWith<$Res> get directionDetails;
}

/// @nodoc
class __$PassengerRideDirectionCopyWithImpl<$Res>
    extends _$PassengerRideStateCopyWithImpl<$Res>
    implements _$PassengerRideDirectionCopyWith<$Res> {
  __$PassengerRideDirectionCopyWithImpl(_PassengerRideDirection _value,
      $Res Function(_PassengerRideDirection) _then)
      : super(_value, (v) => _then(v as _PassengerRideDirection));

  @override
  _PassengerRideDirection get _value => super._value as _PassengerRideDirection;

  @override
  $Res call({
    Object? directionDetails = freezed,
  }) {
    return _then(_PassengerRideDirection(
      directionDetails == freezed
          ? _value.directionDetails
          : directionDetails // ignore: cast_nullable_to_non_nullable
              as DirectionDetails,
    ));
  }

  @override
  $DirectionDetailsCopyWith<$Res> get directionDetails {
    return $DirectionDetailsCopyWith<$Res>(_value.directionDetails, (value) {
      return _then(_value.copyWith(directionDetails: value));
    });
  }
}

/// @nodoc

class _$_PassengerRideDirection implements _PassengerRideDirection {
  const _$_PassengerRideDirection(this.directionDetails);

  @override
  final DirectionDetails directionDetails;

  @override
  String toString() {
    return 'PassengerRideState.direction(directionDetails: $directionDetails)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerRideDirection &&
            const DeepCollectionEquality()
                .equals(other.directionDetails, directionDetails));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(directionDetails));

  @JsonKey(ignore: true)
  @override
  _$PassengerRideDirectionCopyWith<_PassengerRideDirection> get copyWith =>
      __$PassengerRideDirectionCopyWithImpl<_PassengerRideDirection>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function(DirectionDetails directionDetails) direction,
    required TResult Function(String tixId) requesting,
  }) {
    return direction(directionDetails);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
  }) {
    return direction?.call(directionDetails);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
    required TResult orElse(),
  }) {
    if (direction != null) {
      return direction(directionDetails);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerRideError value) error,
    required TResult Function(_PassengerRideInit value) init,
    required TResult Function(_PassengerRideDirection value) direction,
    required TResult Function(_PassengerRideRequesting value) requesting,
  }) {
    return direction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
  }) {
    return direction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
    required TResult orElse(),
  }) {
    if (direction != null) {
      return direction(this);
    }
    return orElse();
  }
}

abstract class _PassengerRideDirection implements PassengerRideState {
  const factory _PassengerRideDirection(DirectionDetails directionDetails) =
      _$_PassengerRideDirection;

  DirectionDetails get directionDetails;
  @JsonKey(ignore: true)
  _$PassengerRideDirectionCopyWith<_PassengerRideDirection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$PassengerRideRequestingCopyWith<$Res> {
  factory _$PassengerRideRequestingCopyWith(_PassengerRideRequesting value,
          $Res Function(_PassengerRideRequesting) then) =
      __$PassengerRideRequestingCopyWithImpl<$Res>;
  $Res call({String tixId});
}

/// @nodoc
class __$PassengerRideRequestingCopyWithImpl<$Res>
    extends _$PassengerRideStateCopyWithImpl<$Res>
    implements _$PassengerRideRequestingCopyWith<$Res> {
  __$PassengerRideRequestingCopyWithImpl(_PassengerRideRequesting _value,
      $Res Function(_PassengerRideRequesting) _then)
      : super(_value, (v) => _then(v as _PassengerRideRequesting));

  @override
  _PassengerRideRequesting get _value =>
      super._value as _PassengerRideRequesting;

  @override
  $Res call({
    Object? tixId = freezed,
  }) {
    return _then(_PassengerRideRequesting(
      tixId == freezed
          ? _value.tixId
          : tixId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PassengerRideRequesting implements _PassengerRideRequesting {
  const _$_PassengerRideRequesting(this.tixId);

  @override
  final String tixId;

  @override
  String toString() {
    return 'PassengerRideState.requesting(tixId: $tixId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerRideRequesting &&
            const DeepCollectionEquality().equals(other.tixId, tixId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(tixId));

  @JsonKey(ignore: true)
  @override
  _$PassengerRideRequestingCopyWith<_PassengerRideRequesting> get copyWith =>
      __$PassengerRideRequestingCopyWithImpl<_PassengerRideRequesting>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function(DirectionDetails directionDetails) direction,
    required TResult Function(String tixId) requesting,
  }) {
    return requesting(tixId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
  }) {
    return requesting?.call(tixId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function(DirectionDetails directionDetails)? direction,
    TResult Function(String tixId)? requesting,
    required TResult orElse(),
  }) {
    if (requesting != null) {
      return requesting(tixId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerRideError value) error,
    required TResult Function(_PassengerRideInit value) init,
    required TResult Function(_PassengerRideDirection value) direction,
    required TResult Function(_PassengerRideRequesting value) requesting,
  }) {
    return requesting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
  }) {
    return requesting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerRideError value)? error,
    TResult Function(_PassengerRideInit value)? init,
    TResult Function(_PassengerRideDirection value)? direction,
    TResult Function(_PassengerRideRequesting value)? requesting,
    required TResult orElse(),
  }) {
    if (requesting != null) {
      return requesting(this);
    }
    return orElse();
  }
}

abstract class _PassengerRideRequesting implements PassengerRideState {
  const factory _PassengerRideRequesting(String tixId) =
      _$_PassengerRideRequesting;

  String get tixId;
  @JsonKey(ignore: true)
  _$PassengerRideRequestingCopyWith<_PassengerRideRequesting> get copyWith =>
      throw _privateConstructorUsedError;
}
