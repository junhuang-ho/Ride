// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'admin.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AdminStateTearOff {
  const _$AdminStateTearOff();

  _AdminInit init() {
    return const _AdminInit();
  }

  _AdminLoading loading() {
    return const _AdminLoading();
  }

  _AdminError error(String? message) {
    return _AdminError(
      message,
    );
  }

  _AdminSuccess success(String? data) {
    return _AdminSuccess(
      data,
    );
  }
}

/// @nodoc
const $AdminState = _$AdminStateTearOff();

/// @nodoc
mixin _$AdminState {
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
    required TResult Function(_AdminInit value) init,
    required TResult Function(_AdminLoading value) loading,
    required TResult Function(_AdminError value) error,
    required TResult Function(_AdminSuccess value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminStateCopyWith<$Res> {
  factory $AdminStateCopyWith(
          AdminState value, $Res Function(AdminState) then) =
      _$AdminStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$AdminStateCopyWithImpl<$Res> implements $AdminStateCopyWith<$Res> {
  _$AdminStateCopyWithImpl(this._value, this._then);

  final AdminState _value;
  // ignore: unused_field
  final $Res Function(AdminState) _then;
}

/// @nodoc
abstract class _$AdminInitCopyWith<$Res> {
  factory _$AdminInitCopyWith(
          _AdminInit value, $Res Function(_AdminInit) then) =
      __$AdminInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$AdminInitCopyWithImpl<$Res> extends _$AdminStateCopyWithImpl<$Res>
    implements _$AdminInitCopyWith<$Res> {
  __$AdminInitCopyWithImpl(_AdminInit _value, $Res Function(_AdminInit) _then)
      : super(_value, (v) => _then(v as _AdminInit));

  @override
  _AdminInit get _value => super._value as _AdminInit;
}

/// @nodoc

class _$_AdminInit implements _AdminInit {
  const _$_AdminInit();

  @override
  String toString() {
    return 'AdminState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _AdminInit);
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
    required TResult Function(_AdminInit value) init,
    required TResult Function(_AdminLoading value) loading,
    required TResult Function(_AdminError value) error,
    required TResult Function(_AdminSuccess value) success,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _AdminInit implements AdminState {
  const factory _AdminInit() = _$_AdminInit;
}

/// @nodoc
abstract class _$AdminLoadingCopyWith<$Res> {
  factory _$AdminLoadingCopyWith(
          _AdminLoading value, $Res Function(_AdminLoading) then) =
      __$AdminLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$AdminLoadingCopyWithImpl<$Res> extends _$AdminStateCopyWithImpl<$Res>
    implements _$AdminLoadingCopyWith<$Res> {
  __$AdminLoadingCopyWithImpl(
      _AdminLoading _value, $Res Function(_AdminLoading) _then)
      : super(_value, (v) => _then(v as _AdminLoading));

  @override
  _AdminLoading get _value => super._value as _AdminLoading;
}

/// @nodoc

class _$_AdminLoading implements _AdminLoading {
  const _$_AdminLoading();

  @override
  String toString() {
    return 'AdminState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _AdminLoading);
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
    required TResult Function(_AdminInit value) init,
    required TResult Function(_AdminLoading value) loading,
    required TResult Function(_AdminError value) error,
    required TResult Function(_AdminSuccess value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _AdminLoading implements AdminState {
  const factory _AdminLoading() = _$_AdminLoading;
}

/// @nodoc
abstract class _$AdminErrorCopyWith<$Res> {
  factory _$AdminErrorCopyWith(
          _AdminError value, $Res Function(_AdminError) then) =
      __$AdminErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$AdminErrorCopyWithImpl<$Res> extends _$AdminStateCopyWithImpl<$Res>
    implements _$AdminErrorCopyWith<$Res> {
  __$AdminErrorCopyWithImpl(
      _AdminError _value, $Res Function(_AdminError) _then)
      : super(_value, (v) => _then(v as _AdminError));

  @override
  _AdminError get _value => super._value as _AdminError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_AdminError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_AdminError implements _AdminError {
  const _$_AdminError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'AdminState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$AdminErrorCopyWith<_AdminError> get copyWith =>
      __$AdminErrorCopyWithImpl<_AdminError>(this, _$identity);

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
    required TResult Function(_AdminInit value) init,
    required TResult Function(_AdminLoading value) loading,
    required TResult Function(_AdminError value) error,
    required TResult Function(_AdminSuccess value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _AdminError implements AdminState {
  const factory _AdminError(String? message) = _$_AdminError;

  String? get message;
  @JsonKey(ignore: true)
  _$AdminErrorCopyWith<_AdminError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$AdminSuccessCopyWith<$Res> {
  factory _$AdminSuccessCopyWith(
          _AdminSuccess value, $Res Function(_AdminSuccess) then) =
      __$AdminSuccessCopyWithImpl<$Res>;
  $Res call({String? data});
}

/// @nodoc
class __$AdminSuccessCopyWithImpl<$Res> extends _$AdminStateCopyWithImpl<$Res>
    implements _$AdminSuccessCopyWith<$Res> {
  __$AdminSuccessCopyWithImpl(
      _AdminSuccess _value, $Res Function(_AdminSuccess) _then)
      : super(_value, (v) => _then(v as _AdminSuccess));

  @override
  _AdminSuccess get _value => super._value as _AdminSuccess;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_AdminSuccess(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_AdminSuccess implements _AdminSuccess {
  const _$_AdminSuccess(this.data);

  @override
  final String? data;

  @override
  String toString() {
    return 'AdminState.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AdminSuccess &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$AdminSuccessCopyWith<_AdminSuccess> get copyWith =>
      __$AdminSuccessCopyWithImpl<_AdminSuccess>(this, _$identity);

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
    required TResult Function(_AdminInit value) init,
    required TResult Function(_AdminLoading value) loading,
    required TResult Function(_AdminError value) error,
    required TResult Function(_AdminSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AdminInit value)? init,
    TResult Function(_AdminLoading value)? loading,
    TResult Function(_AdminError value)? error,
    TResult Function(_AdminSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _AdminSuccess implements AdminState {
  const factory _AdminSuccess(String? data) = _$_AdminSuccess;

  String? get data;
  @JsonKey(ignore: true)
  _$AdminSuccessCopyWith<_AdminSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
