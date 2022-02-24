// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'wallet.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$WalletStateTearOff {
  const _$WalletStateTearOff();

  _WalletLoading loading() {
    return const _WalletLoading();
  }

  _WalletError error(String? message) {
    return _WalletError(
      message,
    );
  }

  _WalletData data(Wallet walletData) {
    return _WalletData(
      walletData,
    );
  }
}

/// @nodoc
const $WalletState = _$WalletStateTearOff();

/// @nodoc
mixin _$WalletState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Wallet walletData) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Wallet walletData)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Wallet walletData)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WalletLoading value) loading,
    required TResult Function(_WalletError value) error,
    required TResult Function(_WalletData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WalletLoading value)? loading,
    TResult Function(_WalletError value)? error,
    TResult Function(_WalletData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WalletLoading value)? loading,
    TResult Function(_WalletError value)? error,
    TResult Function(_WalletData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletStateCopyWith<$Res> {
  factory $WalletStateCopyWith(
          WalletState value, $Res Function(WalletState) then) =
      _$WalletStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$WalletStateCopyWithImpl<$Res> implements $WalletStateCopyWith<$Res> {
  _$WalletStateCopyWithImpl(this._value, this._then);

  final WalletState _value;
  // ignore: unused_field
  final $Res Function(WalletState) _then;
}

/// @nodoc
abstract class _$WalletLoadingCopyWith<$Res> {
  factory _$WalletLoadingCopyWith(
          _WalletLoading value, $Res Function(_WalletLoading) then) =
      __$WalletLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$WalletLoadingCopyWithImpl<$Res> extends _$WalletStateCopyWithImpl<$Res>
    implements _$WalletLoadingCopyWith<$Res> {
  __$WalletLoadingCopyWithImpl(
      _WalletLoading _value, $Res Function(_WalletLoading) _then)
      : super(_value, (v) => _then(v as _WalletLoading));

  @override
  _WalletLoading get _value => super._value as _WalletLoading;
}

/// @nodoc

class _$_WalletLoading implements _WalletLoading {
  const _$_WalletLoading();

  @override
  String toString() {
    return 'WalletState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _WalletLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Wallet walletData) data,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Wallet walletData)? data,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Wallet walletData)? data,
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
    required TResult Function(_WalletLoading value) loading,
    required TResult Function(_WalletError value) error,
    required TResult Function(_WalletData value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WalletLoading value)? loading,
    TResult Function(_WalletError value)? error,
    TResult Function(_WalletData value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WalletLoading value)? loading,
    TResult Function(_WalletError value)? error,
    TResult Function(_WalletData value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _WalletLoading implements WalletState {
  const factory _WalletLoading() = _$_WalletLoading;
}

/// @nodoc
abstract class _$WalletErrorCopyWith<$Res> {
  factory _$WalletErrorCopyWith(
          _WalletError value, $Res Function(_WalletError) then) =
      __$WalletErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$WalletErrorCopyWithImpl<$Res> extends _$WalletStateCopyWithImpl<$Res>
    implements _$WalletErrorCopyWith<$Res> {
  __$WalletErrorCopyWithImpl(
      _WalletError _value, $Res Function(_WalletError) _then)
      : super(_value, (v) => _then(v as _WalletError));

  @override
  _WalletError get _value => super._value as _WalletError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_WalletError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_WalletError implements _WalletError {
  const _$_WalletError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'WalletState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalletError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$WalletErrorCopyWith<_WalletError> get copyWith =>
      __$WalletErrorCopyWithImpl<_WalletError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Wallet walletData) data,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Wallet walletData)? data,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Wallet walletData)? data,
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
    required TResult Function(_WalletLoading value) loading,
    required TResult Function(_WalletError value) error,
    required TResult Function(_WalletData value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WalletLoading value)? loading,
    TResult Function(_WalletError value)? error,
    TResult Function(_WalletData value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WalletLoading value)? loading,
    TResult Function(_WalletError value)? error,
    TResult Function(_WalletData value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _WalletError implements WalletState {
  const factory _WalletError(String? message) = _$_WalletError;

  String? get message;
  @JsonKey(ignore: true)
  _$WalletErrorCopyWith<_WalletError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$WalletDataCopyWith<$Res> {
  factory _$WalletDataCopyWith(
          _WalletData value, $Res Function(_WalletData) then) =
      __$WalletDataCopyWithImpl<$Res>;
  $Res call({Wallet walletData});

  $WalletCopyWith<$Res> get walletData;
}

/// @nodoc
class __$WalletDataCopyWithImpl<$Res> extends _$WalletStateCopyWithImpl<$Res>
    implements _$WalletDataCopyWith<$Res> {
  __$WalletDataCopyWithImpl(
      _WalletData _value, $Res Function(_WalletData) _then)
      : super(_value, (v) => _then(v as _WalletData));

  @override
  _WalletData get _value => super._value as _WalletData;

  @override
  $Res call({
    Object? walletData = freezed,
  }) {
    return _then(_WalletData(
      walletData == freezed
          ? _value.walletData
          : walletData // ignore: cast_nullable_to_non_nullable
              as Wallet,
    ));
  }

  @override
  $WalletCopyWith<$Res> get walletData {
    return $WalletCopyWith<$Res>(_value.walletData, (value) {
      return _then(_value.copyWith(walletData: value));
    });
  }
}

/// @nodoc

class _$_WalletData implements _WalletData {
  const _$_WalletData(this.walletData);

  @override
  final Wallet walletData;

  @override
  String toString() {
    return 'WalletState.data(walletData: $walletData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WalletData &&
            const DeepCollectionEquality()
                .equals(other.walletData, walletData));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(walletData));

  @JsonKey(ignore: true)
  @override
  _$WalletDataCopyWith<_WalletData> get copyWith =>
      __$WalletDataCopyWithImpl<_WalletData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Wallet walletData) data,
  }) {
    return data(walletData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Wallet walletData)? data,
  }) {
    return data?.call(walletData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Wallet walletData)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(walletData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_WalletLoading value) loading,
    required TResult Function(_WalletError value) error,
    required TResult Function(_WalletData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WalletLoading value)? loading,
    TResult Function(_WalletError value)? error,
    TResult Function(_WalletData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WalletLoading value)? loading,
    TResult Function(_WalletError value)? error,
    TResult Function(_WalletData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _WalletData implements WalletState {
  const factory _WalletData(Wallet walletData) = _$_WalletData;

  Wallet get walletData;
  @JsonKey(ignore: true)
  _$WalletDataCopyWith<_WalletData> get copyWith =>
      throw _privateConstructorUsedError;
}
