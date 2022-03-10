// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'apply.driver.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ApplyDriverStateTearOff {
  const _$ApplyDriverStateTearOff();

  _ApplyDriverInit init() {
    return const _ApplyDriverInit();
  }

  _ApplyDriverLoading loading() {
    return const _ApplyDriverLoading();
  }

  _ApplyDriverError error(String? message) {
    return _ApplyDriverError(
      message,
    );
  }

  _ApplyDriverApplied applied() {
    return const _ApplyDriverApplied();
  }
}

/// @nodoc
const $ApplyDriverState = _$ApplyDriverStateTearOff();

/// @nodoc
mixin _$ApplyDriverState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function() applied,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyDriverInit value) init,
    required TResult Function(_ApplyDriverLoading value) loading,
    required TResult Function(_ApplyDriverError value) error,
    required TResult Function(_ApplyDriverApplied value) applied,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplyDriverStateCopyWith<$Res> {
  factory $ApplyDriverStateCopyWith(
          ApplyDriverState value, $Res Function(ApplyDriverState) then) =
      _$ApplyDriverStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$ApplyDriverStateCopyWithImpl<$Res>
    implements $ApplyDriverStateCopyWith<$Res> {
  _$ApplyDriverStateCopyWithImpl(this._value, this._then);

  final ApplyDriverState _value;
  // ignore: unused_field
  final $Res Function(ApplyDriverState) _then;
}

/// @nodoc
abstract class _$ApplyDriverInitCopyWith<$Res> {
  factory _$ApplyDriverInitCopyWith(
          _ApplyDriverInit value, $Res Function(_ApplyDriverInit) then) =
      __$ApplyDriverInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$ApplyDriverInitCopyWithImpl<$Res>
    extends _$ApplyDriverStateCopyWithImpl<$Res>
    implements _$ApplyDriverInitCopyWith<$Res> {
  __$ApplyDriverInitCopyWithImpl(
      _ApplyDriverInit _value, $Res Function(_ApplyDriverInit) _then)
      : super(_value, (v) => _then(v as _ApplyDriverInit));

  @override
  _ApplyDriverInit get _value => super._value as _ApplyDriverInit;
}

/// @nodoc

class _$_ApplyDriverInit
    with DiagnosticableTreeMixin
    implements _ApplyDriverInit {
  const _$_ApplyDriverInit();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApplyDriverState.init()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'ApplyDriverState.init'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ApplyDriverInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function() applied,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
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
    required TResult Function(_ApplyDriverInit value) init,
    required TResult Function(_ApplyDriverLoading value) loading,
    required TResult Function(_ApplyDriverError value) error,
    required TResult Function(_ApplyDriverApplied value) applied,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _ApplyDriverInit implements ApplyDriverState {
  const factory _ApplyDriverInit() = _$_ApplyDriverInit;
}

/// @nodoc
abstract class _$ApplyDriverLoadingCopyWith<$Res> {
  factory _$ApplyDriverLoadingCopyWith(
          _ApplyDriverLoading value, $Res Function(_ApplyDriverLoading) then) =
      __$ApplyDriverLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$ApplyDriverLoadingCopyWithImpl<$Res>
    extends _$ApplyDriverStateCopyWithImpl<$Res>
    implements _$ApplyDriverLoadingCopyWith<$Res> {
  __$ApplyDriverLoadingCopyWithImpl(
      _ApplyDriverLoading _value, $Res Function(_ApplyDriverLoading) _then)
      : super(_value, (v) => _then(v as _ApplyDriverLoading));

  @override
  _ApplyDriverLoading get _value => super._value as _ApplyDriverLoading;
}

/// @nodoc

class _$_ApplyDriverLoading
    with DiagnosticableTreeMixin
    implements _ApplyDriverLoading {
  const _$_ApplyDriverLoading();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApplyDriverState.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'ApplyDriverState.loading'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ApplyDriverLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function() applied,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
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
    required TResult Function(_ApplyDriverInit value) init,
    required TResult Function(_ApplyDriverLoading value) loading,
    required TResult Function(_ApplyDriverError value) error,
    required TResult Function(_ApplyDriverApplied value) applied,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _ApplyDriverLoading implements ApplyDriverState {
  const factory _ApplyDriverLoading() = _$_ApplyDriverLoading;
}

/// @nodoc
abstract class _$ApplyDriverErrorCopyWith<$Res> {
  factory _$ApplyDriverErrorCopyWith(
          _ApplyDriverError value, $Res Function(_ApplyDriverError) then) =
      __$ApplyDriverErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$ApplyDriverErrorCopyWithImpl<$Res>
    extends _$ApplyDriverStateCopyWithImpl<$Res>
    implements _$ApplyDriverErrorCopyWith<$Res> {
  __$ApplyDriverErrorCopyWithImpl(
      _ApplyDriverError _value, $Res Function(_ApplyDriverError) _then)
      : super(_value, (v) => _then(v as _ApplyDriverError));

  @override
  _ApplyDriverError get _value => super._value as _ApplyDriverError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_ApplyDriverError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ApplyDriverError
    with DiagnosticableTreeMixin
    implements _ApplyDriverError {
  const _$_ApplyDriverError(this.message);

  @override
  final String? message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApplyDriverState.error(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ApplyDriverState.error'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ApplyDriverError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$ApplyDriverErrorCopyWith<_ApplyDriverError> get copyWith =>
      __$ApplyDriverErrorCopyWithImpl<_ApplyDriverError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function() applied,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
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
    required TResult Function(_ApplyDriverInit value) init,
    required TResult Function(_ApplyDriverLoading value) loading,
    required TResult Function(_ApplyDriverError value) error,
    required TResult Function(_ApplyDriverApplied value) applied,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ApplyDriverError implements ApplyDriverState {
  const factory _ApplyDriverError(String? message) = _$_ApplyDriverError;

  String? get message;
  @JsonKey(ignore: true)
  _$ApplyDriverErrorCopyWith<_ApplyDriverError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ApplyDriverAppliedCopyWith<$Res> {
  factory _$ApplyDriverAppliedCopyWith(
          _ApplyDriverApplied value, $Res Function(_ApplyDriverApplied) then) =
      __$ApplyDriverAppliedCopyWithImpl<$Res>;
}

/// @nodoc
class __$ApplyDriverAppliedCopyWithImpl<$Res>
    extends _$ApplyDriverStateCopyWithImpl<$Res>
    implements _$ApplyDriverAppliedCopyWith<$Res> {
  __$ApplyDriverAppliedCopyWithImpl(
      _ApplyDriverApplied _value, $Res Function(_ApplyDriverApplied) _then)
      : super(_value, (v) => _then(v as _ApplyDriverApplied));

  @override
  _ApplyDriverApplied get _value => super._value as _ApplyDriverApplied;
}

/// @nodoc

class _$_ApplyDriverApplied
    with DiagnosticableTreeMixin
    implements _ApplyDriverApplied {
  const _$_ApplyDriverApplied();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ApplyDriverState.applied()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'ApplyDriverState.applied'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _ApplyDriverApplied);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function() applied,
  }) {
    return applied();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
  }) {
    return applied?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function()? applied,
    required TResult orElse(),
  }) {
    if (applied != null) {
      return applied();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyDriverInit value) init,
    required TResult Function(_ApplyDriverLoading value) loading,
    required TResult Function(_ApplyDriverError value) error,
    required TResult Function(_ApplyDriverApplied value) applied,
  }) {
    return applied(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
  }) {
    return applied?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyDriverInit value)? init,
    TResult Function(_ApplyDriverLoading value)? loading,
    TResult Function(_ApplyDriverError value)? error,
    TResult Function(_ApplyDriverApplied value)? applied,
    required TResult orElse(),
  }) {
    if (applied != null) {
      return applied(this);
    }
    return orElse();
  }
}

abstract class _ApplyDriverApplied implements ApplyDriverState {
  const factory _ApplyDriverApplied() = _$_ApplyDriverApplied;
}
