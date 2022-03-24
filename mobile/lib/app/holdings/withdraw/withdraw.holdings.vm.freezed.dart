// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'withdraw.holdings.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$WithdrawHoldingsStateTearOff {
  const _$WithdrawHoldingsStateTearOff();

  _WithdrawHoldingsInit init() {
    return const _WithdrawHoldingsInit();
  }

  _WithdrawHoldingsLoading loading() {
    return const _WithdrawHoldingsLoading();
  }

  _WithdrawHoldingsError error(String? message) {
    return _WithdrawHoldingsError(
      message,
    );
  }

  _WithdrawHoldingsSuccess success(String? data) {
    return _WithdrawHoldingsSuccess(
      data,
    );
  }
}

/// @nodoc
const $WithdrawHoldingsState = _$WithdrawHoldingsStateTearOff();

/// @nodoc
mixin _$WithdrawHoldingsState {
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
    required TResult Function(_WithdrawHoldingsInit value) init,
    required TResult Function(_WithdrawHoldingsLoading value) loading,
    required TResult Function(_WithdrawHoldingsError value) error,
    required TResult Function(_WithdrawHoldingsSuccess value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawHoldingsStateCopyWith<$Res> {
  factory $WithdrawHoldingsStateCopyWith(WithdrawHoldingsState value,
          $Res Function(WithdrawHoldingsState) then) =
      _$WithdrawHoldingsStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$WithdrawHoldingsStateCopyWithImpl<$Res>
    implements $WithdrawHoldingsStateCopyWith<$Res> {
  _$WithdrawHoldingsStateCopyWithImpl(this._value, this._then);

  final WithdrawHoldingsState _value;
  // ignore: unused_field
  final $Res Function(WithdrawHoldingsState) _then;
}

/// @nodoc
abstract class _$WithdrawHoldingsInitCopyWith<$Res> {
  factory _$WithdrawHoldingsInitCopyWith(_WithdrawHoldingsInit value,
          $Res Function(_WithdrawHoldingsInit) then) =
      __$WithdrawHoldingsInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$WithdrawHoldingsInitCopyWithImpl<$Res>
    extends _$WithdrawHoldingsStateCopyWithImpl<$Res>
    implements _$WithdrawHoldingsInitCopyWith<$Res> {
  __$WithdrawHoldingsInitCopyWithImpl(
      _WithdrawHoldingsInit _value, $Res Function(_WithdrawHoldingsInit) _then)
      : super(_value, (v) => _then(v as _WithdrawHoldingsInit));

  @override
  _WithdrawHoldingsInit get _value => super._value as _WithdrawHoldingsInit;
}

/// @nodoc

class _$_WithdrawHoldingsInit implements _WithdrawHoldingsInit {
  const _$_WithdrawHoldingsInit();

  @override
  String toString() {
    return 'WithdrawHoldingsState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _WithdrawHoldingsInit);
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
    required TResult Function(_WithdrawHoldingsInit value) init,
    required TResult Function(_WithdrawHoldingsLoading value) loading,
    required TResult Function(_WithdrawHoldingsError value) error,
    required TResult Function(_WithdrawHoldingsSuccess value) success,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _WithdrawHoldingsInit implements WithdrawHoldingsState {
  const factory _WithdrawHoldingsInit() = _$_WithdrawHoldingsInit;
}

/// @nodoc
abstract class _$WithdrawHoldingsLoadingCopyWith<$Res> {
  factory _$WithdrawHoldingsLoadingCopyWith(_WithdrawHoldingsLoading value,
          $Res Function(_WithdrawHoldingsLoading) then) =
      __$WithdrawHoldingsLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$WithdrawHoldingsLoadingCopyWithImpl<$Res>
    extends _$WithdrawHoldingsStateCopyWithImpl<$Res>
    implements _$WithdrawHoldingsLoadingCopyWith<$Res> {
  __$WithdrawHoldingsLoadingCopyWithImpl(_WithdrawHoldingsLoading _value,
      $Res Function(_WithdrawHoldingsLoading) _then)
      : super(_value, (v) => _then(v as _WithdrawHoldingsLoading));

  @override
  _WithdrawHoldingsLoading get _value =>
      super._value as _WithdrawHoldingsLoading;
}

/// @nodoc

class _$_WithdrawHoldingsLoading implements _WithdrawHoldingsLoading {
  const _$_WithdrawHoldingsLoading();

  @override
  String toString() {
    return 'WithdrawHoldingsState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _WithdrawHoldingsLoading);
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
    required TResult Function(_WithdrawHoldingsInit value) init,
    required TResult Function(_WithdrawHoldingsLoading value) loading,
    required TResult Function(_WithdrawHoldingsError value) error,
    required TResult Function(_WithdrawHoldingsSuccess value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _WithdrawHoldingsLoading implements WithdrawHoldingsState {
  const factory _WithdrawHoldingsLoading() = _$_WithdrawHoldingsLoading;
}

/// @nodoc
abstract class _$WithdrawHoldingsErrorCopyWith<$Res> {
  factory _$WithdrawHoldingsErrorCopyWith(_WithdrawHoldingsError value,
          $Res Function(_WithdrawHoldingsError) then) =
      __$WithdrawHoldingsErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$WithdrawHoldingsErrorCopyWithImpl<$Res>
    extends _$WithdrawHoldingsStateCopyWithImpl<$Res>
    implements _$WithdrawHoldingsErrorCopyWith<$Res> {
  __$WithdrawHoldingsErrorCopyWithImpl(_WithdrawHoldingsError _value,
      $Res Function(_WithdrawHoldingsError) _then)
      : super(_value, (v) => _then(v as _WithdrawHoldingsError));

  @override
  _WithdrawHoldingsError get _value => super._value as _WithdrawHoldingsError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_WithdrawHoldingsError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_WithdrawHoldingsError implements _WithdrawHoldingsError {
  const _$_WithdrawHoldingsError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'WithdrawHoldingsState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WithdrawHoldingsError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$WithdrawHoldingsErrorCopyWith<_WithdrawHoldingsError> get copyWith =>
      __$WithdrawHoldingsErrorCopyWithImpl<_WithdrawHoldingsError>(
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
    required TResult Function(_WithdrawHoldingsInit value) init,
    required TResult Function(_WithdrawHoldingsLoading value) loading,
    required TResult Function(_WithdrawHoldingsError value) error,
    required TResult Function(_WithdrawHoldingsSuccess value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _WithdrawHoldingsError implements WithdrawHoldingsState {
  const factory _WithdrawHoldingsError(String? message) =
      _$_WithdrawHoldingsError;

  String? get message;
  @JsonKey(ignore: true)
  _$WithdrawHoldingsErrorCopyWith<_WithdrawHoldingsError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$WithdrawHoldingsSuccessCopyWith<$Res> {
  factory _$WithdrawHoldingsSuccessCopyWith(_WithdrawHoldingsSuccess value,
          $Res Function(_WithdrawHoldingsSuccess) then) =
      __$WithdrawHoldingsSuccessCopyWithImpl<$Res>;
  $Res call({String? data});
}

/// @nodoc
class __$WithdrawHoldingsSuccessCopyWithImpl<$Res>
    extends _$WithdrawHoldingsStateCopyWithImpl<$Res>
    implements _$WithdrawHoldingsSuccessCopyWith<$Res> {
  __$WithdrawHoldingsSuccessCopyWithImpl(_WithdrawHoldingsSuccess _value,
      $Res Function(_WithdrawHoldingsSuccess) _then)
      : super(_value, (v) => _then(v as _WithdrawHoldingsSuccess));

  @override
  _WithdrawHoldingsSuccess get _value =>
      super._value as _WithdrawHoldingsSuccess;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_WithdrawHoldingsSuccess(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_WithdrawHoldingsSuccess implements _WithdrawHoldingsSuccess {
  const _$_WithdrawHoldingsSuccess(this.data);

  @override
  final String? data;

  @override
  String toString() {
    return 'WithdrawHoldingsState.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WithdrawHoldingsSuccess &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$WithdrawHoldingsSuccessCopyWith<_WithdrawHoldingsSuccess> get copyWith =>
      __$WithdrawHoldingsSuccessCopyWithImpl<_WithdrawHoldingsSuccess>(
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
    required TResult Function(_WithdrawHoldingsInit value) init,
    required TResult Function(_WithdrawHoldingsLoading value) loading,
    required TResult Function(_WithdrawHoldingsError value) error,
    required TResult Function(_WithdrawHoldingsSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_WithdrawHoldingsInit value)? init,
    TResult Function(_WithdrawHoldingsLoading value)? loading,
    TResult Function(_WithdrawHoldingsError value)? error,
    TResult Function(_WithdrawHoldingsSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _WithdrawHoldingsSuccess implements WithdrawHoldingsState {
  const factory _WithdrawHoldingsSuccess(String? data) =
      _$_WithdrawHoldingsSuccess;

  String? get data;
  @JsonKey(ignore: true)
  _$WithdrawHoldingsSuccessCopyWith<_WithdrawHoldingsSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
