// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'send.wallet.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SendWalletStateTearOff {
  const _$SendWalletStateTearOff();

  _SendWalletInit init() {
    return const _SendWalletInit();
  }

  _SendWalletLoading loading() {
    return const _SendWalletLoading();
  }

  _SendWalletError error(String? message) {
    return _SendWalletError(
      message,
    );
  }

  _SendWalletSuccess success(String? data) {
    return _SendWalletSuccess(
      data,
    );
  }
}

/// @nodoc
const $SendWalletState = _$SendWalletStateTearOff();

/// @nodoc
mixin _$SendWalletState {
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
    required TResult Function(_SendWalletInit value) init,
    required TResult Function(_SendWalletLoading value) loading,
    required TResult Function(_SendWalletError value) error,
    required TResult Function(_SendWalletSuccess value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendWalletStateCopyWith<$Res> {
  factory $SendWalletStateCopyWith(
          SendWalletState value, $Res Function(SendWalletState) then) =
      _$SendWalletStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$SendWalletStateCopyWithImpl<$Res>
    implements $SendWalletStateCopyWith<$Res> {
  _$SendWalletStateCopyWithImpl(this._value, this._then);

  final SendWalletState _value;
  // ignore: unused_field
  final $Res Function(SendWalletState) _then;
}

/// @nodoc
abstract class _$SendWalletInitCopyWith<$Res> {
  factory _$SendWalletInitCopyWith(
          _SendWalletInit value, $Res Function(_SendWalletInit) then) =
      __$SendWalletInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$SendWalletInitCopyWithImpl<$Res>
    extends _$SendWalletStateCopyWithImpl<$Res>
    implements _$SendWalletInitCopyWith<$Res> {
  __$SendWalletInitCopyWithImpl(
      _SendWalletInit _value, $Res Function(_SendWalletInit) _then)
      : super(_value, (v) => _then(v as _SendWalletInit));

  @override
  _SendWalletInit get _value => super._value as _SendWalletInit;
}

/// @nodoc

class _$_SendWalletInit implements _SendWalletInit {
  const _$_SendWalletInit();

  @override
  String toString() {
    return 'SendWalletState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SendWalletInit);
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
    required TResult Function(_SendWalletInit value) init,
    required TResult Function(_SendWalletLoading value) loading,
    required TResult Function(_SendWalletError value) error,
    required TResult Function(_SendWalletSuccess value) success,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _SendWalletInit implements SendWalletState {
  const factory _SendWalletInit() = _$_SendWalletInit;
}

/// @nodoc
abstract class _$SendWalletLoadingCopyWith<$Res> {
  factory _$SendWalletLoadingCopyWith(
          _SendWalletLoading value, $Res Function(_SendWalletLoading) then) =
      __$SendWalletLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$SendWalletLoadingCopyWithImpl<$Res>
    extends _$SendWalletStateCopyWithImpl<$Res>
    implements _$SendWalletLoadingCopyWith<$Res> {
  __$SendWalletLoadingCopyWithImpl(
      _SendWalletLoading _value, $Res Function(_SendWalletLoading) _then)
      : super(_value, (v) => _then(v as _SendWalletLoading));

  @override
  _SendWalletLoading get _value => super._value as _SendWalletLoading;
}

/// @nodoc

class _$_SendWalletLoading implements _SendWalletLoading {
  const _$_SendWalletLoading();

  @override
  String toString() {
    return 'SendWalletState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SendWalletLoading);
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
    required TResult Function(_SendWalletInit value) init,
    required TResult Function(_SendWalletLoading value) loading,
    required TResult Function(_SendWalletError value) error,
    required TResult Function(_SendWalletSuccess value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _SendWalletLoading implements SendWalletState {
  const factory _SendWalletLoading() = _$_SendWalletLoading;
}

/// @nodoc
abstract class _$SendWalletErrorCopyWith<$Res> {
  factory _$SendWalletErrorCopyWith(
          _SendWalletError value, $Res Function(_SendWalletError) then) =
      __$SendWalletErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$SendWalletErrorCopyWithImpl<$Res>
    extends _$SendWalletStateCopyWithImpl<$Res>
    implements _$SendWalletErrorCopyWith<$Res> {
  __$SendWalletErrorCopyWithImpl(
      _SendWalletError _value, $Res Function(_SendWalletError) _then)
      : super(_value, (v) => _then(v as _SendWalletError));

  @override
  _SendWalletError get _value => super._value as _SendWalletError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_SendWalletError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_SendWalletError implements _SendWalletError {
  const _$_SendWalletError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'SendWalletState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SendWalletError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$SendWalletErrorCopyWith<_SendWalletError> get copyWith =>
      __$SendWalletErrorCopyWithImpl<_SendWalletError>(this, _$identity);

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
    required TResult Function(_SendWalletInit value) init,
    required TResult Function(_SendWalletLoading value) loading,
    required TResult Function(_SendWalletError value) error,
    required TResult Function(_SendWalletSuccess value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _SendWalletError implements SendWalletState {
  const factory _SendWalletError(String? message) = _$_SendWalletError;

  String? get message;
  @JsonKey(ignore: true)
  _$SendWalletErrorCopyWith<_SendWalletError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$SendWalletSuccessCopyWith<$Res> {
  factory _$SendWalletSuccessCopyWith(
          _SendWalletSuccess value, $Res Function(_SendWalletSuccess) then) =
      __$SendWalletSuccessCopyWithImpl<$Res>;
  $Res call({String? data});
}

/// @nodoc
class __$SendWalletSuccessCopyWithImpl<$Res>
    extends _$SendWalletStateCopyWithImpl<$Res>
    implements _$SendWalletSuccessCopyWith<$Res> {
  __$SendWalletSuccessCopyWithImpl(
      _SendWalletSuccess _value, $Res Function(_SendWalletSuccess) _then)
      : super(_value, (v) => _then(v as _SendWalletSuccess));

  @override
  _SendWalletSuccess get _value => super._value as _SendWalletSuccess;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_SendWalletSuccess(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_SendWalletSuccess implements _SendWalletSuccess {
  const _$_SendWalletSuccess(this.data);

  @override
  final String? data;

  @override
  String toString() {
    return 'SendWalletState.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SendWalletSuccess &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$SendWalletSuccessCopyWith<_SendWalletSuccess> get copyWith =>
      __$SendWalletSuccessCopyWithImpl<_SendWalletSuccess>(this, _$identity);

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
    required TResult Function(_SendWalletInit value) init,
    required TResult Function(_SendWalletLoading value) loading,
    required TResult Function(_SendWalletError value) error,
    required TResult Function(_SendWalletSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendWalletInit value)? init,
    TResult Function(_SendWalletLoading value)? loading,
    TResult Function(_SendWalletError value)? error,
    TResult Function(_SendWalletSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _SendWalletSuccess implements SendWalletState {
  const factory _SendWalletSuccess(String? data) = _$_SendWalletSuccess;

  String? get data;
  @JsonKey(ignore: true)
  _$SendWalletSuccessCopyWith<_SendWalletSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
