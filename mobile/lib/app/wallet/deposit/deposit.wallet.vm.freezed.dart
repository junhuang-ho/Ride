// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'deposit.wallet.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DepositWalletStateTearOff {
  const _$DepositWalletStateTearOff();

  _DepositWalletInit init() {
    return const _DepositWalletInit();
  }

  _DepositWalletLoading loading() {
    return const _DepositWalletLoading();
  }

  _DepositWalletError error(String? message) {
    return _DepositWalletError(
      message,
    );
  }

  _DepositWalletSuccess success(String? data) {
    return _DepositWalletSuccess(
      data,
    );
  }
}

/// @nodoc
const $DepositWalletState = _$DepositWalletStateTearOff();

/// @nodoc
mixin _$DepositWalletState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String? data) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DepositWalletInit value) init,
    required TResult Function(_DepositWalletLoading value) loading,
    required TResult Function(_DepositWalletError value) error,
    required TResult Function(_DepositWalletSuccess value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepositWalletStateCopyWith<$Res> {
  factory $DepositWalletStateCopyWith(
          DepositWalletState value, $Res Function(DepositWalletState) then) =
      _$DepositWalletStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DepositWalletStateCopyWithImpl<$Res>
    implements $DepositWalletStateCopyWith<$Res> {
  _$DepositWalletStateCopyWithImpl(this._value, this._then);

  final DepositWalletState _value;
  // ignore: unused_field
  final $Res Function(DepositWalletState) _then;
}

/// @nodoc
abstract class _$DepositWalletInitCopyWith<$Res> {
  factory _$DepositWalletInitCopyWith(
          _DepositWalletInit value, $Res Function(_DepositWalletInit) then) =
      __$DepositWalletInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$DepositWalletInitCopyWithImpl<$Res>
    extends _$DepositWalletStateCopyWithImpl<$Res>
    implements _$DepositWalletInitCopyWith<$Res> {
  __$DepositWalletInitCopyWithImpl(
      _DepositWalletInit _value, $Res Function(_DepositWalletInit) _then)
      : super(_value, (v) => _then(v as _DepositWalletInit));

  @override
  _DepositWalletInit get _value => super._value as _DepositWalletInit;
}

/// @nodoc

class _$_DepositWalletInit implements _DepositWalletInit {
  const _$_DepositWalletInit();

  @override
  String toString() {
    return 'DepositWalletState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DepositWalletInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String? data) success,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
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
    required TResult Function(_DepositWalletInit value) init,
    required TResult Function(_DepositWalletLoading value) loading,
    required TResult Function(_DepositWalletError value) error,
    required TResult Function(_DepositWalletSuccess value) success,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _DepositWalletInit implements DepositWalletState {
  const factory _DepositWalletInit() = _$_DepositWalletInit;
}

/// @nodoc
abstract class _$DepositWalletLoadingCopyWith<$Res> {
  factory _$DepositWalletLoadingCopyWith(_DepositWalletLoading value,
          $Res Function(_DepositWalletLoading) then) =
      __$DepositWalletLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$DepositWalletLoadingCopyWithImpl<$Res>
    extends _$DepositWalletStateCopyWithImpl<$Res>
    implements _$DepositWalletLoadingCopyWith<$Res> {
  __$DepositWalletLoadingCopyWithImpl(
      _DepositWalletLoading _value, $Res Function(_DepositWalletLoading) _then)
      : super(_value, (v) => _then(v as _DepositWalletLoading));

  @override
  _DepositWalletLoading get _value => super._value as _DepositWalletLoading;
}

/// @nodoc

class _$_DepositWalletLoading implements _DepositWalletLoading {
  const _$_DepositWalletLoading();

  @override
  String toString() {
    return 'DepositWalletState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DepositWalletLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String? data) success,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
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
    required TResult Function(_DepositWalletInit value) init,
    required TResult Function(_DepositWalletLoading value) loading,
    required TResult Function(_DepositWalletError value) error,
    required TResult Function(_DepositWalletSuccess value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _DepositWalletLoading implements DepositWalletState {
  const factory _DepositWalletLoading() = _$_DepositWalletLoading;
}

/// @nodoc
abstract class _$DepositWalletErrorCopyWith<$Res> {
  factory _$DepositWalletErrorCopyWith(
          _DepositWalletError value, $Res Function(_DepositWalletError) then) =
      __$DepositWalletErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$DepositWalletErrorCopyWithImpl<$Res>
    extends _$DepositWalletStateCopyWithImpl<$Res>
    implements _$DepositWalletErrorCopyWith<$Res> {
  __$DepositWalletErrorCopyWithImpl(
      _DepositWalletError _value, $Res Function(_DepositWalletError) _then)
      : super(_value, (v) => _then(v as _DepositWalletError));

  @override
  _DepositWalletError get _value => super._value as _DepositWalletError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_DepositWalletError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DepositWalletError implements _DepositWalletError {
  const _$_DepositWalletError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'DepositWalletState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DepositWalletError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$DepositWalletErrorCopyWith<_DepositWalletError> get copyWith =>
      __$DepositWalletErrorCopyWithImpl<_DepositWalletError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String? data) success,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
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
    required TResult Function(_DepositWalletInit value) init,
    required TResult Function(_DepositWalletLoading value) loading,
    required TResult Function(_DepositWalletError value) error,
    required TResult Function(_DepositWalletSuccess value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _DepositWalletError implements DepositWalletState {
  const factory _DepositWalletError(String? message) = _$_DepositWalletError;

  String? get message;
  @JsonKey(ignore: true)
  _$DepositWalletErrorCopyWith<_DepositWalletError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$DepositWalletSuccessCopyWith<$Res> {
  factory _$DepositWalletSuccessCopyWith(_DepositWalletSuccess value,
          $Res Function(_DepositWalletSuccess) then) =
      __$DepositWalletSuccessCopyWithImpl<$Res>;
  $Res call({String? data});
}

/// @nodoc
class __$DepositWalletSuccessCopyWithImpl<$Res>
    extends _$DepositWalletStateCopyWithImpl<$Res>
    implements _$DepositWalletSuccessCopyWith<$Res> {
  __$DepositWalletSuccessCopyWithImpl(
      _DepositWalletSuccess _value, $Res Function(_DepositWalletSuccess) _then)
      : super(_value, (v) => _then(v as _DepositWalletSuccess));

  @override
  _DepositWalletSuccess get _value => super._value as _DepositWalletSuccess;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_DepositWalletSuccess(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DepositWalletSuccess implements _DepositWalletSuccess {
  const _$_DepositWalletSuccess(this.data);

  @override
  final String? data;

  @override
  String toString() {
    return 'DepositWalletState.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DepositWalletSuccess &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$DepositWalletSuccessCopyWith<_DepositWalletSuccess> get copyWith =>
      __$DepositWalletSuccessCopyWithImpl<_DepositWalletSuccess>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String? data) success,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String? data)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DepositWalletInit value) init,
    required TResult Function(_DepositWalletLoading value) loading,
    required TResult Function(_DepositWalletError value) error,
    required TResult Function(_DepositWalletSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositWalletInit value)? init,
    TResult Function(_DepositWalletLoading value)? loading,
    TResult Function(_DepositWalletError value)? error,
    TResult Function(_DepositWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _DepositWalletSuccess implements DepositWalletState {
  const factory _DepositWalletSuccess(String? data) = _$_DepositWalletSuccess;

  String? get data;
  @JsonKey(ignore: true)
  _$DepositWalletSuccessCopyWith<_DepositWalletSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
