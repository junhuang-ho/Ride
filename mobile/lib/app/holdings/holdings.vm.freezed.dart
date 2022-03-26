// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'holdings.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$HoldingsStateTearOff {
  const _$HoldingsStateTearOff();

  _HoldingsLoading loading() {
    return const _HoldingsLoading();
  }

  _HoldingsError error(String? message) {
    return _HoldingsError(
      message,
    );
  }

  _HoldingsData data(BigInt holdingsInCrypto, BigInt holdingsInFiat) {
    return _HoldingsData(
      holdingsInCrypto,
      holdingsInFiat,
    );
  }
}

/// @nodoc
const $HoldingsState = _$HoldingsStateTearOff();

/// @nodoc
mixin _$HoldingsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)
        data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_HoldingsLoading value) loading,
    required TResult Function(_HoldingsError value) error,
    required TResult Function(_HoldingsData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_HoldingsLoading value)? loading,
    TResult Function(_HoldingsError value)? error,
    TResult Function(_HoldingsData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HoldingsLoading value)? loading,
    TResult Function(_HoldingsError value)? error,
    TResult Function(_HoldingsData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HoldingsStateCopyWith<$Res> {
  factory $HoldingsStateCopyWith(
          HoldingsState value, $Res Function(HoldingsState) then) =
      _$HoldingsStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$HoldingsStateCopyWithImpl<$Res>
    implements $HoldingsStateCopyWith<$Res> {
  _$HoldingsStateCopyWithImpl(this._value, this._then);

  final HoldingsState _value;
  // ignore: unused_field
  final $Res Function(HoldingsState) _then;
}

/// @nodoc
abstract class _$HoldingsLoadingCopyWith<$Res> {
  factory _$HoldingsLoadingCopyWith(
          _HoldingsLoading value, $Res Function(_HoldingsLoading) then) =
      __$HoldingsLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$HoldingsLoadingCopyWithImpl<$Res>
    extends _$HoldingsStateCopyWithImpl<$Res>
    implements _$HoldingsLoadingCopyWith<$Res> {
  __$HoldingsLoadingCopyWithImpl(
      _HoldingsLoading _value, $Res Function(_HoldingsLoading) _then)
      : super(_value, (v) => _then(v as _HoldingsLoading));

  @override
  _HoldingsLoading get _value => super._value as _HoldingsLoading;
}

/// @nodoc

class _$_HoldingsLoading implements _HoldingsLoading {
  const _$_HoldingsLoading();

  @override
  String toString() {
    return 'HoldingsState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _HoldingsLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)
        data,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)? data,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)? data,
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
    required TResult Function(_HoldingsLoading value) loading,
    required TResult Function(_HoldingsError value) error,
    required TResult Function(_HoldingsData value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_HoldingsLoading value)? loading,
    TResult Function(_HoldingsError value)? error,
    TResult Function(_HoldingsData value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HoldingsLoading value)? loading,
    TResult Function(_HoldingsError value)? error,
    TResult Function(_HoldingsData value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _HoldingsLoading implements HoldingsState {
  const factory _HoldingsLoading() = _$_HoldingsLoading;
}

/// @nodoc
abstract class _$HoldingsErrorCopyWith<$Res> {
  factory _$HoldingsErrorCopyWith(
          _HoldingsError value, $Res Function(_HoldingsError) then) =
      __$HoldingsErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$HoldingsErrorCopyWithImpl<$Res>
    extends _$HoldingsStateCopyWithImpl<$Res>
    implements _$HoldingsErrorCopyWith<$Res> {
  __$HoldingsErrorCopyWithImpl(
      _HoldingsError _value, $Res Function(_HoldingsError) _then)
      : super(_value, (v) => _then(v as _HoldingsError));

  @override
  _HoldingsError get _value => super._value as _HoldingsError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_HoldingsError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_HoldingsError implements _HoldingsError {
  const _$_HoldingsError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'HoldingsState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HoldingsError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$HoldingsErrorCopyWith<_HoldingsError> get copyWith =>
      __$HoldingsErrorCopyWithImpl<_HoldingsError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)
        data,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)? data,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)? data,
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
    required TResult Function(_HoldingsLoading value) loading,
    required TResult Function(_HoldingsError value) error,
    required TResult Function(_HoldingsData value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_HoldingsLoading value)? loading,
    TResult Function(_HoldingsError value)? error,
    TResult Function(_HoldingsData value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HoldingsLoading value)? loading,
    TResult Function(_HoldingsError value)? error,
    TResult Function(_HoldingsData value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _HoldingsError implements HoldingsState {
  const factory _HoldingsError(String? message) = _$_HoldingsError;

  String? get message;
  @JsonKey(ignore: true)
  _$HoldingsErrorCopyWith<_HoldingsError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$HoldingsDataCopyWith<$Res> {
  factory _$HoldingsDataCopyWith(
          _HoldingsData value, $Res Function(_HoldingsData) then) =
      __$HoldingsDataCopyWithImpl<$Res>;
  $Res call({BigInt holdingsInCrypto, BigInt holdingsInFiat});
}

/// @nodoc
class __$HoldingsDataCopyWithImpl<$Res>
    extends _$HoldingsStateCopyWithImpl<$Res>
    implements _$HoldingsDataCopyWith<$Res> {
  __$HoldingsDataCopyWithImpl(
      _HoldingsData _value, $Res Function(_HoldingsData) _then)
      : super(_value, (v) => _then(v as _HoldingsData));

  @override
  _HoldingsData get _value => super._value as _HoldingsData;

  @override
  $Res call({
    Object? holdingsInCrypto = freezed,
    Object? holdingsInFiat = freezed,
  }) {
    return _then(_HoldingsData(
      holdingsInCrypto == freezed
          ? _value.holdingsInCrypto
          : holdingsInCrypto // ignore: cast_nullable_to_non_nullable
              as BigInt,
      holdingsInFiat == freezed
          ? _value.holdingsInFiat
          : holdingsInFiat // ignore: cast_nullable_to_non_nullable
              as BigInt,
    ));
  }
}

/// @nodoc

class _$_HoldingsData implements _HoldingsData {
  const _$_HoldingsData(this.holdingsInCrypto, this.holdingsInFiat);

  @override
  final BigInt holdingsInCrypto;
  @override
  final BigInt holdingsInFiat;

  @override
  String toString() {
    return 'HoldingsState.data(holdingsInCrypto: $holdingsInCrypto, holdingsInFiat: $holdingsInFiat)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HoldingsData &&
            const DeepCollectionEquality()
                .equals(other.holdingsInCrypto, holdingsInCrypto) &&
            const DeepCollectionEquality()
                .equals(other.holdingsInFiat, holdingsInFiat));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(holdingsInCrypto),
      const DeepCollectionEquality().hash(holdingsInFiat));

  @JsonKey(ignore: true)
  @override
  _$HoldingsDataCopyWith<_HoldingsData> get copyWith =>
      __$HoldingsDataCopyWithImpl<_HoldingsData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)
        data,
  }) {
    return data(holdingsInCrypto, holdingsInFiat);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)? data,
  }) {
    return data?.call(holdingsInCrypto, holdingsInFiat);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(BigInt holdingsInCrypto, BigInt holdingsInFiat)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(holdingsInCrypto, holdingsInFiat);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_HoldingsLoading value) loading,
    required TResult Function(_HoldingsError value) error,
    required TResult Function(_HoldingsData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_HoldingsLoading value)? loading,
    TResult Function(_HoldingsError value)? error,
    TResult Function(_HoldingsData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_HoldingsLoading value)? loading,
    TResult Function(_HoldingsError value)? error,
    TResult Function(_HoldingsData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _HoldingsData implements HoldingsState {
  const factory _HoldingsData(BigInt holdingsInCrypto, BigInt holdingsInFiat) =
      _$_HoldingsData;

  BigInt get holdingsInCrypto;
  BigInt get holdingsInFiat;
  @JsonKey(ignore: true)
  _$HoldingsDataCopyWith<_HoldingsData> get copyWith =>
      throw _privateConstructorUsedError;
}
