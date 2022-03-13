// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'withdraw.wallet.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$WithdrawWalletStateTearOff {
  const _$WithdrawWalletStateTearOff();

  _WithdrawWalletInit init() {
    return const _WithdrawWalletInit();
  }

  _WithdrawWalletLoading loading() {
    return const _WithdrawWalletLoading();
  }

  _WithdrawWalletError error(String? message) {
    return _WithdrawWalletError(
      message,
    );
  }

  _WithdrawWalletSuccess success(String? data) {
    return _WithdrawWalletSuccess(
      data,
    );
  }
}

/// @nodoc
const $WithdrawWalletState = _$WithdrawWalletStateTearOff();

/// @nodoc
mixin _$WithdrawWalletState {
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
    required TResult Function(_WithdrawWalletInit value) init,
    required TResult Function(_WithdrawWalletLoading value) loading,
    required TResult Function(_WithdrawWalletError value) error,
    required TResult Function(_WithdrawWalletSuccess value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawWalletStateCopyWith<$Res> {
  factory $WithdrawWalletStateCopyWith(
          WithdrawWalletState value, $Res Function(WithdrawWalletState) then) =
      _$WithdrawWalletStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$WithdrawWalletStateCopyWithImpl<$Res>
    implements $WithdrawWalletStateCopyWith<$Res> {
  _$WithdrawWalletStateCopyWithImpl(this._value, this._then);

  final WithdrawWalletState _value;
  // ignore: unused_field
  final $Res Function(WithdrawWalletState) _then;
}

/// @nodoc
abstract class _$WithdrawWalletInitCopyWith<$Res> {
  factory _$WithdrawWalletInitCopyWith(
          _WithdrawWalletInit value, $Res Function(_WithdrawWalletInit) then) =
      __$WithdrawWalletInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$WithdrawWalletInitCopyWithImpl<$Res>
    extends _$WithdrawWalletStateCopyWithImpl<$Res>
    implements _$WithdrawWalletInitCopyWith<$Res> {
  __$WithdrawWalletInitCopyWithImpl(
      _WithdrawWalletInit _value, $Res Function(_WithdrawWalletInit) _then)
      : super(_value, (v) => _then(v as _WithdrawWalletInit));

  @override
  _WithdrawWalletInit get _value => super._value as _WithdrawWalletInit;
}

/// @nodoc

class _$_WithdrawWalletInit implements _WithdrawWalletInit {
  const _$_WithdrawWalletInit();

  @override
  String toString() {
    return 'WithdrawWalletState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _WithdrawWalletInit);
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
    required TResult Function(_WithdrawWalletInit value) init,
    required TResult Function(_WithdrawWalletLoading value) loading,
    required TResult Function(_WithdrawWalletError value) error,
    required TResult Function(_WithdrawWalletSuccess value) success,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _WithdrawWalletInit implements WithdrawWalletState {
  const factory _WithdrawWalletInit() = _$_WithdrawWalletInit;
}

/// @nodoc
abstract class _$WithdrawWalletLoadingCopyWith<$Res> {
  factory _$WithdrawWalletLoadingCopyWith(_WithdrawWalletLoading value,
          $Res Function(_WithdrawWalletLoading) then) =
      __$WithdrawWalletLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$WithdrawWalletLoadingCopyWithImpl<$Res>
    extends _$WithdrawWalletStateCopyWithImpl<$Res>
    implements _$WithdrawWalletLoadingCopyWith<$Res> {
  __$WithdrawWalletLoadingCopyWithImpl(_WithdrawWalletLoading _value,
      $Res Function(_WithdrawWalletLoading) _then)
      : super(_value, (v) => _then(v as _WithdrawWalletLoading));

  @override
  _WithdrawWalletLoading get _value => super._value as _WithdrawWalletLoading;
}

/// @nodoc

class _$_WithdrawWalletLoading implements _WithdrawWalletLoading {
  const _$_WithdrawWalletLoading();

  @override
  String toString() {
    return 'WithdrawWalletState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _WithdrawWalletLoading);
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
    required TResult Function(_WithdrawWalletInit value) init,
    required TResult Function(_WithdrawWalletLoading value) loading,
    required TResult Function(_WithdrawWalletError value) error,
    required TResult Function(_WithdrawWalletSuccess value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _WithdrawWalletLoading implements WithdrawWalletState {
  const factory _WithdrawWalletLoading() = _$_WithdrawWalletLoading;
}

/// @nodoc
abstract class _$WithdrawWalletErrorCopyWith<$Res> {
  factory _$WithdrawWalletErrorCopyWith(_WithdrawWalletError value,
          $Res Function(_WithdrawWalletError) then) =
      __$WithdrawWalletErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$WithdrawWalletErrorCopyWithImpl<$Res>
    extends _$WithdrawWalletStateCopyWithImpl<$Res>
    implements _$WithdrawWalletErrorCopyWith<$Res> {
  __$WithdrawWalletErrorCopyWithImpl(
      _WithdrawWalletError _value, $Res Function(_WithdrawWalletError) _then)
      : super(_value, (v) => _then(v as _WithdrawWalletError));

  @override
  _WithdrawWalletError get _value => super._value as _WithdrawWalletError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_WithdrawWalletError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_WithdrawWalletError implements _WithdrawWalletError {
  const _$_WithdrawWalletError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'WithdrawWalletState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WithdrawWalletError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$WithdrawWalletErrorCopyWith<_WithdrawWalletError> get copyWith =>
      __$WithdrawWalletErrorCopyWithImpl<_WithdrawWalletError>(
          this, _$identity);

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
    required TResult Function(_WithdrawWalletInit value) init,
    required TResult Function(_WithdrawWalletLoading value) loading,
    required TResult Function(_WithdrawWalletError value) error,
    required TResult Function(_WithdrawWalletSuccess value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _WithdrawWalletError implements WithdrawWalletState {
  const factory _WithdrawWalletError(String? message) = _$_WithdrawWalletError;

  String? get message;
  @JsonKey(ignore: true)
  _$WithdrawWalletErrorCopyWith<_WithdrawWalletError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$WithdrawWalletSuccessCopyWith<$Res> {
  factory _$WithdrawWalletSuccessCopyWith(_WithdrawWalletSuccess value,
          $Res Function(_WithdrawWalletSuccess) then) =
      __$WithdrawWalletSuccessCopyWithImpl<$Res>;
  $Res call({String? data});
}

/// @nodoc
class __$WithdrawWalletSuccessCopyWithImpl<$Res>
    extends _$WithdrawWalletStateCopyWithImpl<$Res>
    implements _$WithdrawWalletSuccessCopyWith<$Res> {
  __$WithdrawWalletSuccessCopyWithImpl(_WithdrawWalletSuccess _value,
      $Res Function(_WithdrawWalletSuccess) _then)
      : super(_value, (v) => _then(v as _WithdrawWalletSuccess));

  @override
  _WithdrawWalletSuccess get _value => super._value as _WithdrawWalletSuccess;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_WithdrawWalletSuccess(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_WithdrawWalletSuccess implements _WithdrawWalletSuccess {
  const _$_WithdrawWalletSuccess(this.data);

  @override
  final String? data;

  @override
  String toString() {
    return 'WithdrawWalletState.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WithdrawWalletSuccess &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$WithdrawWalletSuccessCopyWith<_WithdrawWalletSuccess> get copyWith =>
      __$WithdrawWalletSuccessCopyWithImpl<_WithdrawWalletSuccess>(
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
    required TResult Function(_WithdrawWalletInit value) init,
    required TResult Function(_WithdrawWalletLoading value) loading,
    required TResult Function(_WithdrawWalletError value) error,
    required TResult Function(_WithdrawWalletSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawWalletInit value)? init,
    TResult Function(_WithdrawWalletLoading value)? loading,
    TResult Function(_WithdrawWalletError value)? error,
    TResult Function(_WithdrawWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _WithdrawWalletSuccess implements WithdrawWalletState {
  const factory _WithdrawWalletSuccess(String? data) = _$_WithdrawWalletSuccess;

  String? get data;
  @JsonKey(ignore: true)
  _$WithdrawWalletSuccessCopyWith<_WithdrawWalletSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
