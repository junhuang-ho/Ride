// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'deposit.holdings.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DepositHoldingsStateTearOff {
  const _$DepositHoldingsStateTearOff();

  _DepositHoldingsInit init() {
    return const _DepositHoldingsInit();
  }

  _DepositHoldingsLoading loading() {
    return const _DepositHoldingsLoading();
  }

  _DepositHoldingsError error(String? message) {
    return _DepositHoldingsError(
      message,
    );
  }

  _DepositHoldingsSuccess success(String? data) {
    return _DepositHoldingsSuccess(
      data,
    );
  }
}

/// @nodoc
const $DepositHoldingsState = _$DepositHoldingsStateTearOff();

/// @nodoc
mixin _$DepositHoldingsState {
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
    required TResult Function(_DepositHoldingsInit value) init,
    required TResult Function(_DepositHoldingsLoading value) loading,
    required TResult Function(_DepositHoldingsError value) error,
    required TResult Function(_DepositHoldingsSuccess value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DepositHoldingsStateCopyWith<$Res> {
  factory $DepositHoldingsStateCopyWith(DepositHoldingsState value,
          $Res Function(DepositHoldingsState) then) =
      _$DepositHoldingsStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DepositHoldingsStateCopyWithImpl<$Res>
    implements $DepositHoldingsStateCopyWith<$Res> {
  _$DepositHoldingsStateCopyWithImpl(this._value, this._then);

  final DepositHoldingsState _value;
  // ignore: unused_field
  final $Res Function(DepositHoldingsState) _then;
}

/// @nodoc
abstract class _$DepositHoldingsInitCopyWith<$Res> {
  factory _$DepositHoldingsInitCopyWith(_DepositHoldingsInit value,
          $Res Function(_DepositHoldingsInit) then) =
      __$DepositHoldingsInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$DepositHoldingsInitCopyWithImpl<$Res>
    extends _$DepositHoldingsStateCopyWithImpl<$Res>
    implements _$DepositHoldingsInitCopyWith<$Res> {
  __$DepositHoldingsInitCopyWithImpl(
      _DepositHoldingsInit _value, $Res Function(_DepositHoldingsInit) _then)
      : super(_value, (v) => _then(v as _DepositHoldingsInit));

  @override
  _DepositHoldingsInit get _value => super._value as _DepositHoldingsInit;
}

/// @nodoc

class _$_DepositHoldingsInit implements _DepositHoldingsInit {
  const _$_DepositHoldingsInit();

  @override
  String toString() {
    return 'DepositHoldingsState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DepositHoldingsInit);
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
    required TResult Function(_DepositHoldingsInit value) init,
    required TResult Function(_DepositHoldingsLoading value) loading,
    required TResult Function(_DepositHoldingsError value) error,
    required TResult Function(_DepositHoldingsSuccess value) success,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _DepositHoldingsInit implements DepositHoldingsState {
  const factory _DepositHoldingsInit() = _$_DepositHoldingsInit;
}

/// @nodoc
abstract class _$DepositHoldingsLoadingCopyWith<$Res> {
  factory _$DepositHoldingsLoadingCopyWith(_DepositHoldingsLoading value,
          $Res Function(_DepositHoldingsLoading) then) =
      __$DepositHoldingsLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$DepositHoldingsLoadingCopyWithImpl<$Res>
    extends _$DepositHoldingsStateCopyWithImpl<$Res>
    implements _$DepositHoldingsLoadingCopyWith<$Res> {
  __$DepositHoldingsLoadingCopyWithImpl(_DepositHoldingsLoading _value,
      $Res Function(_DepositHoldingsLoading) _then)
      : super(_value, (v) => _then(v as _DepositHoldingsLoading));

  @override
  _DepositHoldingsLoading get _value => super._value as _DepositHoldingsLoading;
}

/// @nodoc

class _$_DepositHoldingsLoading implements _DepositHoldingsLoading {
  const _$_DepositHoldingsLoading();

  @override
  String toString() {
    return 'DepositHoldingsState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _DepositHoldingsLoading);
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
    required TResult Function(_DepositHoldingsInit value) init,
    required TResult Function(_DepositHoldingsLoading value) loading,
    required TResult Function(_DepositHoldingsError value) error,
    required TResult Function(_DepositHoldingsSuccess value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _DepositHoldingsLoading implements DepositHoldingsState {
  const factory _DepositHoldingsLoading() = _$_DepositHoldingsLoading;
}

/// @nodoc
abstract class _$DepositHoldingsErrorCopyWith<$Res> {
  factory _$DepositHoldingsErrorCopyWith(_DepositHoldingsError value,
          $Res Function(_DepositHoldingsError) then) =
      __$DepositHoldingsErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$DepositHoldingsErrorCopyWithImpl<$Res>
    extends _$DepositHoldingsStateCopyWithImpl<$Res>
    implements _$DepositHoldingsErrorCopyWith<$Res> {
  __$DepositHoldingsErrorCopyWithImpl(
      _DepositHoldingsError _value, $Res Function(_DepositHoldingsError) _then)
      : super(_value, (v) => _then(v as _DepositHoldingsError));

  @override
  _DepositHoldingsError get _value => super._value as _DepositHoldingsError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_DepositHoldingsError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DepositHoldingsError implements _DepositHoldingsError {
  const _$_DepositHoldingsError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'DepositHoldingsState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DepositHoldingsError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$DepositHoldingsErrorCopyWith<_DepositHoldingsError> get copyWith =>
      __$DepositHoldingsErrorCopyWithImpl<_DepositHoldingsError>(
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
    required TResult Function(_DepositHoldingsInit value) init,
    required TResult Function(_DepositHoldingsLoading value) loading,
    required TResult Function(_DepositHoldingsError value) error,
    required TResult Function(_DepositHoldingsSuccess value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _DepositHoldingsError implements DepositHoldingsState {
  const factory _DepositHoldingsError(String? message) =
      _$_DepositHoldingsError;

  String? get message;
  @JsonKey(ignore: true)
  _$DepositHoldingsErrorCopyWith<_DepositHoldingsError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$DepositHoldingsSuccessCopyWith<$Res> {
  factory _$DepositHoldingsSuccessCopyWith(_DepositHoldingsSuccess value,
          $Res Function(_DepositHoldingsSuccess) then) =
      __$DepositHoldingsSuccessCopyWithImpl<$Res>;
  $Res call({String? data});
}

/// @nodoc
class __$DepositHoldingsSuccessCopyWithImpl<$Res>
    extends _$DepositHoldingsStateCopyWithImpl<$Res>
    implements _$DepositHoldingsSuccessCopyWith<$Res> {
  __$DepositHoldingsSuccessCopyWithImpl(_DepositHoldingsSuccess _value,
      $Res Function(_DepositHoldingsSuccess) _then)
      : super(_value, (v) => _then(v as _DepositHoldingsSuccess));

  @override
  _DepositHoldingsSuccess get _value => super._value as _DepositHoldingsSuccess;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_DepositHoldingsSuccess(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DepositHoldingsSuccess implements _DepositHoldingsSuccess {
  const _$_DepositHoldingsSuccess(this.data);

  @override
  final String? data;

  @override
  String toString() {
    return 'DepositHoldingsState.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DepositHoldingsSuccess &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$DepositHoldingsSuccessCopyWith<_DepositHoldingsSuccess> get copyWith =>
      __$DepositHoldingsSuccessCopyWithImpl<_DepositHoldingsSuccess>(
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
    required TResult Function(_DepositHoldingsInit value) init,
    required TResult Function(_DepositHoldingsLoading value) loading,
    required TResult Function(_DepositHoldingsError value) error,
    required TResult Function(_DepositHoldingsSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DepositHoldingsInit value)? init,
    TResult Function(_DepositHoldingsLoading value)? loading,
    TResult Function(_DepositHoldingsError value)? error,
    TResult Function(_DepositHoldingsSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _DepositHoldingsSuccess implements DepositHoldingsState {
  const factory _DepositHoldingsSuccess(String? data) =
      _$_DepositHoldingsSuccess;

  String? get data;
  @JsonKey(ignore: true)
  _$DepositHoldingsSuccessCopyWith<_DepositHoldingsSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
