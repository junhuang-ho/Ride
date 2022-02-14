// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'setup.wallet.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SetupWalletStateTearOff {
  const _$SetupWalletStateTearOff();

  _SetupWalletLoading loading() {
    return const _SetupWalletLoading();
  }

  _SetupWalletError error(String? message) {
    return _SetupWalletError(
      message,
    );
  }

  _SetupWalletDisplay display({required String mnemonic}) {
    return _SetupWalletDisplay(
      mnemonic: mnemonic,
    );
  }

  _SetupWalletConfirm confirm({required String generatedMnemonic}) {
    return _SetupWalletConfirm(
      generatedMnemonic: generatedMnemonic,
    );
  }
}

/// @nodoc
const $SetupWalletState = _$SetupWalletStateTearOff();

/// @nodoc
mixin _$SetupWalletState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String mnemonic) display,
    required TResult Function(String generatedMnemonic) confirm,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetupWalletLoading value) loading,
    required TResult Function(_SetupWalletError value) error,
    required TResult Function(_SetupWalletDisplay value) display,
    required TResult Function(_SetupWalletConfirm value) confirm,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetupWalletStateCopyWith<$Res> {
  factory $SetupWalletStateCopyWith(
          SetupWalletState value, $Res Function(SetupWalletState) then) =
      _$SetupWalletStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$SetupWalletStateCopyWithImpl<$Res>
    implements $SetupWalletStateCopyWith<$Res> {
  _$SetupWalletStateCopyWithImpl(this._value, this._then);

  final SetupWalletState _value;
  // ignore: unused_field
  final $Res Function(SetupWalletState) _then;
}

/// @nodoc
abstract class _$SetupWalletLoadingCopyWith<$Res> {
  factory _$SetupWalletLoadingCopyWith(
          _SetupWalletLoading value, $Res Function(_SetupWalletLoading) then) =
      __$SetupWalletLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$SetupWalletLoadingCopyWithImpl<$Res>
    extends _$SetupWalletStateCopyWithImpl<$Res>
    implements _$SetupWalletLoadingCopyWith<$Res> {
  __$SetupWalletLoadingCopyWithImpl(
      _SetupWalletLoading _value, $Res Function(_SetupWalletLoading) _then)
      : super(_value, (v) => _then(v as _SetupWalletLoading));

  @override
  _SetupWalletLoading get _value => super._value as _SetupWalletLoading;
}

/// @nodoc

class _$_SetupWalletLoading implements _SetupWalletLoading {
  const _$_SetupWalletLoading();

  @override
  String toString() {
    return 'SetupWalletState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _SetupWalletLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String mnemonic) display,
    required TResult Function(String generatedMnemonic) confirm,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
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
    required TResult Function(_SetupWalletLoading value) loading,
    required TResult Function(_SetupWalletError value) error,
    required TResult Function(_SetupWalletDisplay value) display,
    required TResult Function(_SetupWalletConfirm value) confirm,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _SetupWalletLoading implements SetupWalletState {
  const factory _SetupWalletLoading() = _$_SetupWalletLoading;
}

/// @nodoc
abstract class _$SetupWalletErrorCopyWith<$Res> {
  factory _$SetupWalletErrorCopyWith(
          _SetupWalletError value, $Res Function(_SetupWalletError) then) =
      __$SetupWalletErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$SetupWalletErrorCopyWithImpl<$Res>
    extends _$SetupWalletStateCopyWithImpl<$Res>
    implements _$SetupWalletErrorCopyWith<$Res> {
  __$SetupWalletErrorCopyWithImpl(
      _SetupWalletError _value, $Res Function(_SetupWalletError) _then)
      : super(_value, (v) => _then(v as _SetupWalletError));

  @override
  _SetupWalletError get _value => super._value as _SetupWalletError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_SetupWalletError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_SetupWalletError implements _SetupWalletError {
  const _$_SetupWalletError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'SetupWalletState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SetupWalletError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$SetupWalletErrorCopyWith<_SetupWalletError> get copyWith =>
      __$SetupWalletErrorCopyWithImpl<_SetupWalletError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String mnemonic) display,
    required TResult Function(String generatedMnemonic) confirm,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
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
    required TResult Function(_SetupWalletLoading value) loading,
    required TResult Function(_SetupWalletError value) error,
    required TResult Function(_SetupWalletDisplay value) display,
    required TResult Function(_SetupWalletConfirm value) confirm,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _SetupWalletError implements SetupWalletState {
  const factory _SetupWalletError(String? message) = _$_SetupWalletError;

  String? get message;
  @JsonKey(ignore: true)
  _$SetupWalletErrorCopyWith<_SetupWalletError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$SetupWalletDisplayCopyWith<$Res> {
  factory _$SetupWalletDisplayCopyWith(
          _SetupWalletDisplay value, $Res Function(_SetupWalletDisplay) then) =
      __$SetupWalletDisplayCopyWithImpl<$Res>;
  $Res call({String mnemonic});
}

/// @nodoc
class __$SetupWalletDisplayCopyWithImpl<$Res>
    extends _$SetupWalletStateCopyWithImpl<$Res>
    implements _$SetupWalletDisplayCopyWith<$Res> {
  __$SetupWalletDisplayCopyWithImpl(
      _SetupWalletDisplay _value, $Res Function(_SetupWalletDisplay) _then)
      : super(_value, (v) => _then(v as _SetupWalletDisplay));

  @override
  _SetupWalletDisplay get _value => super._value as _SetupWalletDisplay;

  @override
  $Res call({
    Object? mnemonic = freezed,
  }) {
    return _then(_SetupWalletDisplay(
      mnemonic: mnemonic == freezed
          ? _value.mnemonic
          : mnemonic // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SetupWalletDisplay implements _SetupWalletDisplay {
  const _$_SetupWalletDisplay({required this.mnemonic});

  @override
  final String mnemonic;

  @override
  String toString() {
    return 'SetupWalletState.display(mnemonic: $mnemonic)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SetupWalletDisplay &&
            const DeepCollectionEquality().equals(other.mnemonic, mnemonic));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(mnemonic));

  @JsonKey(ignore: true)
  @override
  _$SetupWalletDisplayCopyWith<_SetupWalletDisplay> get copyWith =>
      __$SetupWalletDisplayCopyWithImpl<_SetupWalletDisplay>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String mnemonic) display,
    required TResult Function(String generatedMnemonic) confirm,
  }) {
    return display(mnemonic);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
  }) {
    return display?.call(mnemonic);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
    required TResult orElse(),
  }) {
    if (display != null) {
      return display(mnemonic);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetupWalletLoading value) loading,
    required TResult Function(_SetupWalletError value) error,
    required TResult Function(_SetupWalletDisplay value) display,
    required TResult Function(_SetupWalletConfirm value) confirm,
  }) {
    return display(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
  }) {
    return display?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
    required TResult orElse(),
  }) {
    if (display != null) {
      return display(this);
    }
    return orElse();
  }
}

abstract class _SetupWalletDisplay implements SetupWalletState {
  const factory _SetupWalletDisplay({required String mnemonic}) =
      _$_SetupWalletDisplay;

  String get mnemonic;
  @JsonKey(ignore: true)
  _$SetupWalletDisplayCopyWith<_SetupWalletDisplay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$SetupWalletConfirmCopyWith<$Res> {
  factory _$SetupWalletConfirmCopyWith(
          _SetupWalletConfirm value, $Res Function(_SetupWalletConfirm) then) =
      __$SetupWalletConfirmCopyWithImpl<$Res>;
  $Res call({String generatedMnemonic});
}

/// @nodoc
class __$SetupWalletConfirmCopyWithImpl<$Res>
    extends _$SetupWalletStateCopyWithImpl<$Res>
    implements _$SetupWalletConfirmCopyWith<$Res> {
  __$SetupWalletConfirmCopyWithImpl(
      _SetupWalletConfirm _value, $Res Function(_SetupWalletConfirm) _then)
      : super(_value, (v) => _then(v as _SetupWalletConfirm));

  @override
  _SetupWalletConfirm get _value => super._value as _SetupWalletConfirm;

  @override
  $Res call({
    Object? generatedMnemonic = freezed,
  }) {
    return _then(_SetupWalletConfirm(
      generatedMnemonic: generatedMnemonic == freezed
          ? _value.generatedMnemonic
          : generatedMnemonic // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SetupWalletConfirm implements _SetupWalletConfirm {
  const _$_SetupWalletConfirm({required this.generatedMnemonic});

  @override
  final String generatedMnemonic;

  @override
  String toString() {
    return 'SetupWalletState.confirm(generatedMnemonic: $generatedMnemonic)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SetupWalletConfirm &&
            const DeepCollectionEquality()
                .equals(other.generatedMnemonic, generatedMnemonic));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(generatedMnemonic));

  @JsonKey(ignore: true)
  @override
  _$SetupWalletConfirmCopyWith<_SetupWalletConfirm> get copyWith =>
      __$SetupWalletConfirmCopyWithImpl<_SetupWalletConfirm>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(String mnemonic) display,
    required TResult Function(String generatedMnemonic) confirm,
  }) {
    return confirm(generatedMnemonic);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
  }) {
    return confirm?.call(generatedMnemonic);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(String mnemonic)? display,
    TResult Function(String generatedMnemonic)? confirm,
    required TResult orElse(),
  }) {
    if (confirm != null) {
      return confirm(generatedMnemonic);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_SetupWalletLoading value) loading,
    required TResult Function(_SetupWalletError value) error,
    required TResult Function(_SetupWalletDisplay value) display,
    required TResult Function(_SetupWalletConfirm value) confirm,
  }) {
    return confirm(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
  }) {
    return confirm?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_SetupWalletLoading value)? loading,
    TResult Function(_SetupWalletError value)? error,
    TResult Function(_SetupWalletDisplay value)? display,
    TResult Function(_SetupWalletConfirm value)? confirm,
    required TResult orElse(),
  }) {
    if (confirm != null) {
      return confirm(this);
    }
    return orElse();
  }
}

abstract class _SetupWalletConfirm implements SetupWalletState {
  const factory _SetupWalletConfirm({required String generatedMnemonic}) =
      _$_SetupWalletConfirm;

  String get generatedMnemonic;
  @JsonKey(ignore: true)
  _$SetupWalletConfirmCopyWith<_SetupWalletConfirm> get copyWith =>
      throw _privateConstructorUsedError;
}
