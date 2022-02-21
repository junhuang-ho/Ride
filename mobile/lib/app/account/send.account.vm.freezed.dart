// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'send.account.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SendAccountStateTearOff {
  const _$SendAccountStateTearOff();

  _SendAccountInit init() {
    return const _SendAccountInit();
  }

  _SendAccountLoading loading() {
    return const _SendAccountLoading();
  }

  _SendAccountError error(String? message) {
    return _SendAccountError(
      message,
    );
  }

  _SendAccountSuccess success(String? data) {
    return _SendAccountSuccess(
      data,
    );
  }
}

/// @nodoc
const $SendAccountState = _$SendAccountStateTearOff();

/// @nodoc
mixin _$SendAccountState {
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
    required TResult Function(_SendAccountInit value) init,
    required TResult Function(_SendAccountLoading value) loading,
    required TResult Function(_SendAccountError value) error,
    required TResult Function(_SendAccountSuccess value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendAccountStateCopyWith<$Res> {
  factory $SendAccountStateCopyWith(
          SendAccountState value, $Res Function(SendAccountState) then) =
      _$SendAccountStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$SendAccountStateCopyWithImpl<$Res>
    implements $SendAccountStateCopyWith<$Res> {
  _$SendAccountStateCopyWithImpl(this._value, this._then);

  final SendAccountState _value;
  // ignore: unused_field
  final $Res Function(SendAccountState) _then;
}

/// @nodoc
abstract class _$SendAccountInitCopyWith<$Res> {
  factory _$SendAccountInitCopyWith(
          _SendAccountInit value, $Res Function(_SendAccountInit) then) =
      __$SendAccountInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$SendAccountInitCopyWithImpl<$Res>
    extends _$SendAccountStateCopyWithImpl<$Res>
    implements _$SendAccountInitCopyWith<$Res> {
  __$SendAccountInitCopyWithImpl(
      _SendAccountInit _value, $Res Function(_SendAccountInit) _then)
      : super(_value, (v) => _then(v as _SendAccountInit));

  @override
  _SendAccountInit get _value => super._value as _SendAccountInit;
}

/// @nodoc

class _$_SendAccountInit implements _SendAccountInit {
  const _$_SendAccountInit();

  @override
  String toString() {
    return 'SendAccountState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SendAccountInit);
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
    required TResult Function(_SendAccountInit value) init,
    required TResult Function(_SendAccountLoading value) loading,
    required TResult Function(_SendAccountError value) error,
    required TResult Function(_SendAccountSuccess value) success,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _SendAccountInit implements SendAccountState {
  const factory _SendAccountInit() = _$_SendAccountInit;
}

/// @nodoc
abstract class _$SendAccountLoadingCopyWith<$Res> {
  factory _$SendAccountLoadingCopyWith(
          _SendAccountLoading value, $Res Function(_SendAccountLoading) then) =
      __$SendAccountLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$SendAccountLoadingCopyWithImpl<$Res>
    extends _$SendAccountStateCopyWithImpl<$Res>
    implements _$SendAccountLoadingCopyWith<$Res> {
  __$SendAccountLoadingCopyWithImpl(
      _SendAccountLoading _value, $Res Function(_SendAccountLoading) _then)
      : super(_value, (v) => _then(v as _SendAccountLoading));

  @override
  _SendAccountLoading get _value => super._value as _SendAccountLoading;
}

/// @nodoc

class _$_SendAccountLoading implements _SendAccountLoading {
  const _$_SendAccountLoading();

  @override
  String toString() {
    return 'SendAccountState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SendAccountLoading);
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
    required TResult Function(_SendAccountInit value) init,
    required TResult Function(_SendAccountLoading value) loading,
    required TResult Function(_SendAccountError value) error,
    required TResult Function(_SendAccountSuccess value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _SendAccountLoading implements SendAccountState {
  const factory _SendAccountLoading() = _$_SendAccountLoading;
}

/// @nodoc
abstract class _$SendAccountErrorCopyWith<$Res> {
  factory _$SendAccountErrorCopyWith(
          _SendAccountError value, $Res Function(_SendAccountError) then) =
      __$SendAccountErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$SendAccountErrorCopyWithImpl<$Res>
    extends _$SendAccountStateCopyWithImpl<$Res>
    implements _$SendAccountErrorCopyWith<$Res> {
  __$SendAccountErrorCopyWithImpl(
      _SendAccountError _value, $Res Function(_SendAccountError) _then)
      : super(_value, (v) => _then(v as _SendAccountError));

  @override
  _SendAccountError get _value => super._value as _SendAccountError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_SendAccountError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_SendAccountError implements _SendAccountError {
  const _$_SendAccountError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'SendAccountState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SendAccountError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$SendAccountErrorCopyWith<_SendAccountError> get copyWith =>
      __$SendAccountErrorCopyWithImpl<_SendAccountError>(this, _$identity);

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
    required TResult Function(_SendAccountInit value) init,
    required TResult Function(_SendAccountLoading value) loading,
    required TResult Function(_SendAccountError value) error,
    required TResult Function(_SendAccountSuccess value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _SendAccountError implements SendAccountState {
  const factory _SendAccountError(String? message) = _$_SendAccountError;

  String? get message;
  @JsonKey(ignore: true)
  _$SendAccountErrorCopyWith<_SendAccountError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$SendAccountSuccessCopyWith<$Res> {
  factory _$SendAccountSuccessCopyWith(
          _SendAccountSuccess value, $Res Function(_SendAccountSuccess) then) =
      __$SendAccountSuccessCopyWithImpl<$Res>;
  $Res call({String? data});
}

/// @nodoc
class __$SendAccountSuccessCopyWithImpl<$Res>
    extends _$SendAccountStateCopyWithImpl<$Res>
    implements _$SendAccountSuccessCopyWith<$Res> {
  __$SendAccountSuccessCopyWithImpl(
      _SendAccountSuccess _value, $Res Function(_SendAccountSuccess) _then)
      : super(_value, (v) => _then(v as _SendAccountSuccess));

  @override
  _SendAccountSuccess get _value => super._value as _SendAccountSuccess;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_SendAccountSuccess(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_SendAccountSuccess implements _SendAccountSuccess {
  const _$_SendAccountSuccess(this.data);

  @override
  final String? data;

  @override
  String toString() {
    return 'SendAccountState.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SendAccountSuccess &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$SendAccountSuccessCopyWith<_SendAccountSuccess> get copyWith =>
      __$SendAccountSuccessCopyWithImpl<_SendAccountSuccess>(this, _$identity);

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
    required TResult Function(_SendAccountInit value) init,
    required TResult Function(_SendAccountLoading value) loading,
    required TResult Function(_SendAccountError value) error,
    required TResult Function(_SendAccountSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SendAccountInit value)? init,
    TResult Function(_SendAccountLoading value)? loading,
    TResult Function(_SendAccountError value)? error,
    TResult Function(_SendAccountSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _SendAccountSuccess implements SendAccountState {
  const factory _SendAccountSuccess(String? data) = _$_SendAccountSuccess;

  String? get data;
  @JsonKey(ignore: true)
  _$SendAccountSuccessCopyWith<_SendAccountSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
