// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'driver.profile.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DriverProfileStateTearOff {
  const _$DriverProfileStateTearOff();

  _DriverProfileLoading loading() {
    return const _DriverProfileLoading();
  }

  _DriverProfileError error(String? message) {
    return _DriverProfileError(
      message,
    );
  }

  _DriverProfileData data(DriverReputation driverReputation) {
    return _DriverProfileData(
      driverReputation,
    );
  }
}

/// @nodoc
const $DriverProfileState = _$DriverProfileStateTearOff();

/// @nodoc
mixin _$DriverProfileState {
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
    required TResult Function(_DriverProfileLoading value) loading,
    required TResult Function(_DriverProfileError value) error,
    required TResult Function(_DriverProfileData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverProfileLoading value)? loading,
    TResult Function(_DriverProfileError value)? error,
    TResult Function(_DriverProfileData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverProfileLoading value)? loading,
    TResult Function(_DriverProfileError value)? error,
    TResult Function(_DriverProfileData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverProfileStateCopyWith<$Res> {
  factory $DriverProfileStateCopyWith(
          DriverProfileState value, $Res Function(DriverProfileState) then) =
      _$DriverProfileStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DriverProfileStateCopyWithImpl<$Res>
    implements $DriverProfileStateCopyWith<$Res> {
  _$DriverProfileStateCopyWithImpl(this._value, this._then);

  final DriverProfileState _value;
  // ignore: unused_field
  final $Res Function(DriverProfileState) _then;
}

/// @nodoc
abstract class _$DriverProfileLoadingCopyWith<$Res> {
  factory _$DriverProfileLoadingCopyWith(_DriverProfileLoading value,
          $Res Function(_DriverProfileLoading) then) =
      __$DriverProfileLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$DriverProfileLoadingCopyWithImpl<$Res>
    extends _$DriverProfileStateCopyWithImpl<$Res>
    implements _$DriverProfileLoadingCopyWith<$Res> {
  __$DriverProfileLoadingCopyWithImpl(
      _DriverProfileLoading _value, $Res Function(_DriverProfileLoading) _then)
      : super(_value, (v) => _then(v as _DriverProfileLoading));

  @override
  _DriverProfileLoading get _value => super._value as _DriverProfileLoading;
}

/// @nodoc

class _$_DriverProfileLoading implements _DriverProfileLoading {
  const _$_DriverProfileLoading();

  @override
  String toString() {
    return 'DriverProfileState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DriverProfileLoading);
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
    required TResult Function(_DriverProfileLoading value) loading,
    required TResult Function(_DriverProfileError value) error,
    required TResult Function(_DriverProfileData value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverProfileLoading value)? loading,
    TResult Function(_DriverProfileError value)? error,
    TResult Function(_DriverProfileData value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverProfileLoading value)? loading,
    TResult Function(_DriverProfileError value)? error,
    TResult Function(_DriverProfileData value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _DriverProfileLoading implements DriverProfileState {
  const factory _DriverProfileLoading() = _$_DriverProfileLoading;
}

/// @nodoc
abstract class _$DriverProfileErrorCopyWith<$Res> {
  factory _$DriverProfileErrorCopyWith(
          _DriverProfileError value, $Res Function(_DriverProfileError) then) =
      __$DriverProfileErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$DriverProfileErrorCopyWithImpl<$Res>
    extends _$DriverProfileStateCopyWithImpl<$Res>
    implements _$DriverProfileErrorCopyWith<$Res> {
  __$DriverProfileErrorCopyWithImpl(
      _DriverProfileError _value, $Res Function(_DriverProfileError) _then)
      : super(_value, (v) => _then(v as _DriverProfileError));

  @override
  _DriverProfileError get _value => super._value as _DriverProfileError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_DriverProfileError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DriverProfileError implements _DriverProfileError {
  const _$_DriverProfileError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'DriverProfileState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverProfileError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$DriverProfileErrorCopyWith<_DriverProfileError> get copyWith =>
      __$DriverProfileErrorCopyWithImpl<_DriverProfileError>(this, _$identity);

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
    required TResult Function(_DriverProfileLoading value) loading,
    required TResult Function(_DriverProfileError value) error,
    required TResult Function(_DriverProfileData value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverProfileLoading value)? loading,
    TResult Function(_DriverProfileError value)? error,
    TResult Function(_DriverProfileData value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverProfileLoading value)? loading,
    TResult Function(_DriverProfileError value)? error,
    TResult Function(_DriverProfileData value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _DriverProfileError implements DriverProfileState {
  const factory _DriverProfileError(String? message) = _$_DriverProfileError;

  String? get message;
  @JsonKey(ignore: true)
  _$DriverProfileErrorCopyWith<_DriverProfileError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$DriverProfileDataCopyWith<$Res> {
  factory _$DriverProfileDataCopyWith(
          _DriverProfileData value, $Res Function(_DriverProfileData) then) =
      __$DriverProfileDataCopyWithImpl<$Res>;
  $Res call({DriverReputation driverReputation});

  $DriverReputationCopyWith<$Res> get driverReputation;
}

/// @nodoc
class __$DriverProfileDataCopyWithImpl<$Res>
    extends _$DriverProfileStateCopyWithImpl<$Res>
    implements _$DriverProfileDataCopyWith<$Res> {
  __$DriverProfileDataCopyWithImpl(
      _DriverProfileData _value, $Res Function(_DriverProfileData) _then)
      : super(_value, (v) => _then(v as _DriverProfileData));

  @override
  _DriverProfileData get _value => super._value as _DriverProfileData;

  @override
  $Res call({
    Object? driverReputation = freezed,
  }) {
    return _then(_DriverProfileData(
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

class _$_DriverProfileData implements _DriverProfileData {
  const _$_DriverProfileData(this.driverReputation);

  @override
  final DriverReputation driverReputation;

  @override
  String toString() {
    return 'DriverProfileState.data(driverReputation: $driverReputation)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DriverProfileData &&
            const DeepCollectionEquality()
                .equals(other.driverReputation, driverReputation));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(driverReputation));

  @JsonKey(ignore: true)
  @override
  _$DriverProfileDataCopyWith<_DriverProfileData> get copyWith =>
      __$DriverProfileDataCopyWithImpl<_DriverProfileData>(this, _$identity);

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
    required TResult Function(_DriverProfileLoading value) loading,
    required TResult Function(_DriverProfileError value) error,
    required TResult Function(_DriverProfileData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DriverProfileLoading value)? loading,
    TResult Function(_DriverProfileError value)? error,
    TResult Function(_DriverProfileData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DriverProfileLoading value)? loading,
    TResult Function(_DriverProfileError value)? error,
    TResult Function(_DriverProfileData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _DriverProfileData implements DriverProfileState {
  const factory _DriverProfileData(DriverReputation driverReputation) =
      _$_DriverProfileData;

  DriverReputation get driverReputation;
  @JsonKey(ignore: true)
  _$DriverProfileDataCopyWith<_DriverProfileData> get copyWith =>
      throw _privateConstructorUsedError;
}
