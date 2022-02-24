// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'passenger.home.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PassengerHomeStateTearOff {
  const _$PassengerHomeStateTearOff();

  _PassengerHomeLoading loading() {
    return const _PassengerHomeLoading();
  }

  _PassengerHomeError error(String? message) {
    return _PassengerHomeError(
      message,
    );
  }

  _PassengerHomeData data(Account account) {
    return _PassengerHomeData(
      account,
    );
  }
}

/// @nodoc
const $PassengerHomeState = _$PassengerHomeStateTearOff();

/// @nodoc
mixin _$PassengerHomeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Account account) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Account account)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Account account)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassengerHomeStateCopyWith<$Res> {
  factory $PassengerHomeStateCopyWith(
          PassengerHomeState value, $Res Function(PassengerHomeState) then) =
      _$PassengerHomeStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$PassengerHomeStateCopyWithImpl<$Res>
    implements $PassengerHomeStateCopyWith<$Res> {
  _$PassengerHomeStateCopyWithImpl(this._value, this._then);

  final PassengerHomeState _value;
  // ignore: unused_field
  final $Res Function(PassengerHomeState) _then;
}

/// @nodoc
abstract class _$PassengerHomeLoadingCopyWith<$Res> {
  factory _$PassengerHomeLoadingCopyWith(_PassengerHomeLoading value,
          $Res Function(_PassengerHomeLoading) then) =
      __$PassengerHomeLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$PassengerHomeLoadingCopyWithImpl<$Res>
    extends _$PassengerHomeStateCopyWithImpl<$Res>
    implements _$PassengerHomeLoadingCopyWith<$Res> {
  __$PassengerHomeLoadingCopyWithImpl(
      _PassengerHomeLoading _value, $Res Function(_PassengerHomeLoading) _then)
      : super(_value, (v) => _then(v as _PassengerHomeLoading));

  @override
  _PassengerHomeLoading get _value => super._value as _PassengerHomeLoading;
}

/// @nodoc

class _$_PassengerHomeLoading implements _PassengerHomeLoading {
  const _$_PassengerHomeLoading();

  @override
  String toString() {
    return 'PassengerHomeState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _PassengerHomeLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Account account) data,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Account account)? data,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Account account)? data,
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
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _PassengerHomeLoading implements PassengerHomeState {
  const factory _PassengerHomeLoading() = _$_PassengerHomeLoading;
}

/// @nodoc
abstract class _$PassengerHomeErrorCopyWith<$Res> {
  factory _$PassengerHomeErrorCopyWith(
          _PassengerHomeError value, $Res Function(_PassengerHomeError) then) =
      __$PassengerHomeErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$PassengerHomeErrorCopyWithImpl<$Res>
    extends _$PassengerHomeStateCopyWithImpl<$Res>
    implements _$PassengerHomeErrorCopyWith<$Res> {
  __$PassengerHomeErrorCopyWithImpl(
      _PassengerHomeError _value, $Res Function(_PassengerHomeError) _then)
      : super(_value, (v) => _then(v as _PassengerHomeError));

  @override
  _PassengerHomeError get _value => super._value as _PassengerHomeError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_PassengerHomeError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_PassengerHomeError implements _PassengerHomeError {
  const _$_PassengerHomeError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'PassengerHomeState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerHomeError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$PassengerHomeErrorCopyWith<_PassengerHomeError> get copyWith =>
      __$PassengerHomeErrorCopyWithImpl<_PassengerHomeError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Account account) data,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Account account)? data,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Account account)? data,
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
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _PassengerHomeError implements PassengerHomeState {
  const factory _PassengerHomeError(String? message) = _$_PassengerHomeError;

  String? get message;
  @JsonKey(ignore: true)
  _$PassengerHomeErrorCopyWith<_PassengerHomeError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$PassengerHomeDataCopyWith<$Res> {
  factory _$PassengerHomeDataCopyWith(
          _PassengerHomeData value, $Res Function(_PassengerHomeData) then) =
      __$PassengerHomeDataCopyWithImpl<$Res>;
  $Res call({Account account});

  $AccountCopyWith<$Res> get account;
}

/// @nodoc
class __$PassengerHomeDataCopyWithImpl<$Res>
    extends _$PassengerHomeStateCopyWithImpl<$Res>
    implements _$PassengerHomeDataCopyWith<$Res> {
  __$PassengerHomeDataCopyWithImpl(
      _PassengerHomeData _value, $Res Function(_PassengerHomeData) _then)
      : super(_value, (v) => _then(v as _PassengerHomeData));

  @override
  _PassengerHomeData get _value => super._value as _PassengerHomeData;

  @override
  $Res call({
    Object? account = freezed,
  }) {
    return _then(_PassengerHomeData(
      account == freezed
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
    ));
  }

  @override
  $AccountCopyWith<$Res> get account {
    return $AccountCopyWith<$Res>(_value.account, (value) {
      return _then(_value.copyWith(account: value));
    });
  }
}

/// @nodoc

class _$_PassengerHomeData implements _PassengerHomeData {
  const _$_PassengerHomeData(this.account);

  @override
  final Account account;

  @override
  String toString() {
    return 'PassengerHomeState.data(account: $account)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerHomeData &&
            const DeepCollectionEquality().equals(other.account, account));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(account));

  @JsonKey(ignore: true)
  @override
  _$PassengerHomeDataCopyWith<_PassengerHomeData> get copyWith =>
      __$PassengerHomeDataCopyWithImpl<_PassengerHomeData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Account account) data,
  }) {
    return data(account);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Account account)? data,
  }) {
    return data?.call(account);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Account account)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(account);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _PassengerHomeData implements PassengerHomeState {
  const factory _PassengerHomeData(Account account) = _$_PassengerHomeData;

  Account get account;
  @JsonKey(ignore: true)
  _$PassengerHomeDataCopyWith<_PassengerHomeData> get copyWith =>
      throw _privateConstructorUsedError;
}
