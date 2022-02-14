// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'account.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AccountStateTearOff {
  const _$AccountStateTearOff();

  _AccountLoading loading() {
    return const _AccountLoading();
  }

  _AccountError error(String? message) {
    return _AccountError(
      message,
    );
  }

  _AccountData data(Account account) {
    return _AccountData(
      account,
    );
  }
}

/// @nodoc
const $AccountState = _$AccountStateTearOff();

/// @nodoc
mixin _$AccountState {
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
    required TResult Function(_AccountLoading value) loading,
    required TResult Function(_AccountError value) error,
    required TResult Function(_AccountData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AccountLoading value)? loading,
    TResult Function(_AccountError value)? error,
    TResult Function(_AccountData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AccountLoading value)? loading,
    TResult Function(_AccountError value)? error,
    TResult Function(_AccountData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountStateCopyWith<$Res> {
  factory $AccountStateCopyWith(
          AccountState value, $Res Function(AccountState) then) =
      _$AccountStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$AccountStateCopyWithImpl<$Res> implements $AccountStateCopyWith<$Res> {
  _$AccountStateCopyWithImpl(this._value, this._then);

  final AccountState _value;
  // ignore: unused_field
  final $Res Function(AccountState) _then;
}

/// @nodoc
abstract class _$AccountLoadingCopyWith<$Res> {
  factory _$AccountLoadingCopyWith(
          _AccountLoading value, $Res Function(_AccountLoading) then) =
      __$AccountLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$AccountLoadingCopyWithImpl<$Res>
    extends _$AccountStateCopyWithImpl<$Res>
    implements _$AccountLoadingCopyWith<$Res> {
  __$AccountLoadingCopyWithImpl(
      _AccountLoading _value, $Res Function(_AccountLoading) _then)
      : super(_value, (v) => _then(v as _AccountLoading));

  @override
  _AccountLoading get _value => super._value as _AccountLoading;
}

/// @nodoc

class _$_AccountLoading implements _AccountLoading {
  const _$_AccountLoading();

  @override
  String toString() {
    return 'AccountState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _AccountLoading);
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
    required TResult Function(_AccountLoading value) loading,
    required TResult Function(_AccountError value) error,
    required TResult Function(_AccountData value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AccountLoading value)? loading,
    TResult Function(_AccountError value)? error,
    TResult Function(_AccountData value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AccountLoading value)? loading,
    TResult Function(_AccountError value)? error,
    TResult Function(_AccountData value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _AccountLoading implements AccountState {
  const factory _AccountLoading() = _$_AccountLoading;
}

/// @nodoc
abstract class _$AccountErrorCopyWith<$Res> {
  factory _$AccountErrorCopyWith(
          _AccountError value, $Res Function(_AccountError) then) =
      __$AccountErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$AccountErrorCopyWithImpl<$Res> extends _$AccountStateCopyWithImpl<$Res>
    implements _$AccountErrorCopyWith<$Res> {
  __$AccountErrorCopyWithImpl(
      _AccountError _value, $Res Function(_AccountError) _then)
      : super(_value, (v) => _then(v as _AccountError));

  @override
  _AccountError get _value => super._value as _AccountError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_AccountError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_AccountError implements _AccountError {
  const _$_AccountError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'AccountState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$AccountErrorCopyWith<_AccountError> get copyWith =>
      __$AccountErrorCopyWithImpl<_AccountError>(this, _$identity);

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
    required TResult Function(_AccountLoading value) loading,
    required TResult Function(_AccountError value) error,
    required TResult Function(_AccountData value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AccountLoading value)? loading,
    TResult Function(_AccountError value)? error,
    TResult Function(_AccountData value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AccountLoading value)? loading,
    TResult Function(_AccountError value)? error,
    TResult Function(_AccountData value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _AccountError implements AccountState {
  const factory _AccountError(String? message) = _$_AccountError;

  String? get message;
  @JsonKey(ignore: true)
  _$AccountErrorCopyWith<_AccountError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$AccountDataCopyWith<$Res> {
  factory _$AccountDataCopyWith(
          _AccountData value, $Res Function(_AccountData) then) =
      __$AccountDataCopyWithImpl<$Res>;
  $Res call({Account account});
}

/// @nodoc
class __$AccountDataCopyWithImpl<$Res> extends _$AccountStateCopyWithImpl<$Res>
    implements _$AccountDataCopyWith<$Res> {
  __$AccountDataCopyWithImpl(
      _AccountData _value, $Res Function(_AccountData) _then)
      : super(_value, (v) => _then(v as _AccountData));

  @override
  _AccountData get _value => super._value as _AccountData;

  @override
  $Res call({
    Object? account = freezed,
  }) {
    return _then(_AccountData(
      account == freezed
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
    ));
  }
}

/// @nodoc

class _$_AccountData implements _AccountData {
  const _$_AccountData(this.account);

  @override
  final Account account;

  @override
  String toString() {
    return 'AccountState.data(account: $account)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountData &&
            const DeepCollectionEquality().equals(other.account, account));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(account));

  @JsonKey(ignore: true)
  @override
  _$AccountDataCopyWith<_AccountData> get copyWith =>
      __$AccountDataCopyWithImpl<_AccountData>(this, _$identity);

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
    required TResult Function(_AccountLoading value) loading,
    required TResult Function(_AccountError value) error,
    required TResult Function(_AccountData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AccountLoading value)? loading,
    TResult Function(_AccountError value)? error,
    TResult Function(_AccountData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AccountLoading value)? loading,
    TResult Function(_AccountError value)? error,
    TResult Function(_AccountData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _AccountData implements AccountState {
  const factory _AccountData(Account account) = _$_AccountData;

  Account get account;
  @JsonKey(ignore: true)
  _$AccountDataCopyWith<_AccountData> get copyWith =>
      throw _privateConstructorUsedError;
}
