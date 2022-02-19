// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'driver.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DriverStateTearOff {
  const _$DriverStateTearOff();

  _DriverLoading loading() {
    return const _DriverLoading();
  }

  _DriverError error(String? message) {
    return _DriverError(
      message,
    );
  }

  _DriverData data(DriverReputation driverReputation) {
    return _DriverData(
      driverReputation,
    );
  }
}

/// @nodoc
const $DriverState = _$DriverStateTearOff();

/// @nodoc
mixin _$DriverState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(DriverReputation driverReputation) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(DriverReputation driverReputation)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(DriverReputation driverReputation)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DriverLoading value) loading,
    required TResult Function(_DriverError value) error,
    required TResult Function(_DriverData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverLoading value)? loading,
    TResult Function(_DriverError value)? error,
    TResult Function(_DriverData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverLoading value)? loading,
    TResult Function(_DriverError value)? error,
    TResult Function(_DriverData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverStateCopyWith<$Res> {
  factory $DriverStateCopyWith(
          DriverState value, $Res Function(DriverState) then) =
      _$DriverStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DriverStateCopyWithImpl<$Res> implements $DriverStateCopyWith<$Res> {
  _$DriverStateCopyWithImpl(this._value, this._then);

  final DriverState _value;
  // ignore: unused_field
  final $Res Function(DriverState) _then;
}

/// @nodoc
abstract class _$DriverLoadingCopyWith<$Res> {
  factory _$DriverLoadingCopyWith(
          _DriverLoading value, $Res Function(_DriverLoading) then) =
      __$DriverLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$DriverLoadingCopyWithImpl<$Res> extends _$DriverStateCopyWithImpl<$Res>
    implements _$DriverLoadingCopyWith<$Res> {
  __$DriverLoadingCopyWithImpl(
      _DriverLoading _value, $Res Function(_DriverLoading) _then)
      : super(_value, (v) => _then(v as _DriverLoading));

  @override
  _DriverLoading get _value => super._value as _DriverLoading;
}

/// @nodoc

class _$_DriverLoading implements _DriverLoading {
  const _$_DriverLoading();

  @override
  String toString() {
    return 'DriverState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DriverLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(DriverReputation driverReputation) data,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(DriverReputation driverReputation)? data,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(DriverReputation driverReputation)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DriverLoading value) loading,
    required TResult Function(_DriverError value) error,
    required TResult Function(_DriverData value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverLoading value)? loading,
    TResult Function(_DriverError value)? error,
    TResult Function(_DriverData value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverLoading value)? loading,
    TResult Function(_DriverError value)? error,
    TResult Function(_DriverData value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _DriverLoading implements DriverState {
  const factory _DriverLoading() = _$_DriverLoading;
}

/// @nodoc
abstract class _$DriverErrorCopyWith<$Res> {
  factory _$DriverErrorCopyWith(
          _DriverError value, $Res Function(_DriverError) then) =
      __$DriverErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$DriverErrorCopyWithImpl<$Res> extends _$DriverStateCopyWithImpl<$Res>
    implements _$DriverErrorCopyWith<$Res> {
  __$DriverErrorCopyWithImpl(
      _DriverError _value, $Res Function(_DriverError) _then)
      : super(_value, (v) => _then(v as _DriverError));

  @override
  _DriverError get _value => super._value as _DriverError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_DriverError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DriverError implements _DriverError {
  const _$_DriverError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'DriverState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$DriverErrorCopyWith<_DriverError> get copyWith =>
      __$DriverErrorCopyWithImpl<_DriverError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(DriverReputation driverReputation) data,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(DriverReputation driverReputation)? data,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(DriverReputation driverReputation)? data,
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
    required TResult Function(_DriverLoading value) loading,
    required TResult Function(_DriverError value) error,
    required TResult Function(_DriverData value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverLoading value)? loading,
    TResult Function(_DriverError value)? error,
    TResult Function(_DriverData value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverLoading value)? loading,
    TResult Function(_DriverError value)? error,
    TResult Function(_DriverData value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _DriverError implements DriverState {
  const factory _DriverError(String? message) = _$_DriverError;

  String? get message;
  @JsonKey(ignore: true)
  _$DriverErrorCopyWith<_DriverError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$DriverDataCopyWith<$Res> {
  factory _$DriverDataCopyWith(
          _DriverData value, $Res Function(_DriverData) then) =
      __$DriverDataCopyWithImpl<$Res>;
  $Res call({DriverReputation driverReputation});

  $DriverReputationCopyWith<$Res> get driverReputation;
}

/// @nodoc
class __$DriverDataCopyWithImpl<$Res> extends _$DriverStateCopyWithImpl<$Res>
    implements _$DriverDataCopyWith<$Res> {
  __$DriverDataCopyWithImpl(
      _DriverData _value, $Res Function(_DriverData) _then)
      : super(_value, (v) => _then(v as _DriverData));

  @override
  _DriverData get _value => super._value as _DriverData;

  @override
  $Res call({
    Object? driverReputation = freezed,
  }) {
    return _then(_DriverData(
      driverReputation == freezed
          ? _value.driverReputation
          : driverReputation // ignore: cast_nullable_to_non_nullable
              as DriverReputation,
    ));
  }

  @override
  $DriverReputationCopyWith<$Res> get driverReputation {
    return $DriverReputationCopyWith<$Res>(_value.driverReputation, (value) {
      return _then(_value.copyWith(driverReputation: value));
    });
  }
}

/// @nodoc

class _$_DriverData implements _DriverData {
  const _$_DriverData(this.driverReputation);

  @override
  final DriverReputation driverReputation;

  @override
  String toString() {
    return 'DriverState.data(driverReputation: $driverReputation)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverData &&
            const DeepCollectionEquality()
                .equals(other.driverReputation, driverReputation));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(driverReputation));

  @JsonKey(ignore: true)
  @override
  _$DriverDataCopyWith<_DriverData> get copyWith =>
      __$DriverDataCopyWithImpl<_DriverData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(DriverReputation driverReputation) data,
  }) {
    return data(driverReputation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(DriverReputation driverReputation)? data,
  }) {
    return data?.call(driverReputation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(DriverReputation driverReputation)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(driverReputation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DriverLoading value) loading,
    required TResult Function(_DriverError value) error,
    required TResult Function(_DriverData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverLoading value)? loading,
    TResult Function(_DriverError value)? error,
    TResult Function(_DriverData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverLoading value)? loading,
    TResult Function(_DriverError value)? error,
    TResult Function(_DriverData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _DriverData implements DriverState {
  const factory _DriverData(DriverReputation driverReputation) = _$_DriverData;

  DriverReputation get driverReputation;
  @JsonKey(ignore: true)
  _$DriverDataCopyWith<_DriverData> get copyWith =>
      throw _privateConstructorUsedError;
}
