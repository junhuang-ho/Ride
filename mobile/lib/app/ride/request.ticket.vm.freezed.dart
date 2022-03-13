// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'request.ticket.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$RequestTicketStateTearOff {
  const _$RequestTicketStateTearOff();

  _RequestTicketInit init() {
    return const _RequestTicketInit();
  }

  _RequestTicketRequesting requesting() {
    return const _RequestTicketRequesting();
  }

  _RequestTicketRequested requested(String? txnId) {
    return _RequestTicketRequested(
      txnId,
    );
  }

  _RequestTicketCancelling cancelling() {
    return const _RequestTicketCancelling();
  }

  _RequestTicketCancelled cancelled(String? txnId) {
    return _RequestTicketCancelled(
      txnId,
    );
  }

  _RequestTicketError error(String? message) {
    return _RequestTicketError(
      message,
    );
  }

  _RequestTicketLoading loading() {
    return const _RequestTicketLoading();
  }

  _RequestTicketSuccess data(String? tixId) {
    return _RequestTicketSuccess(
      tixId,
    );
  }
}

/// @nodoc
const $RequestTicketState = _$RequestTicketStateTearOff();

/// @nodoc
mixin _$RequestTicketState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestTicketStateCopyWith<$Res> {
  factory $RequestTicketStateCopyWith(
          RequestTicketState value, $Res Function(RequestTicketState) then) =
      _$RequestTicketStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$RequestTicketStateCopyWithImpl<$Res>
    implements $RequestTicketStateCopyWith<$Res> {
  _$RequestTicketStateCopyWithImpl(this._value, this._then);

  final RequestTicketState _value;
  // ignore: unused_field
  final $Res Function(RequestTicketState) _then;
}

/// @nodoc
abstract class _$RequestTicketInitCopyWith<$Res> {
  factory _$RequestTicketInitCopyWith(
          _RequestTicketInit value, $Res Function(_RequestTicketInit) then) =
      __$RequestTicketInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$RequestTicketInitCopyWithImpl<$Res>
    extends _$RequestTicketStateCopyWithImpl<$Res>
    implements _$RequestTicketInitCopyWith<$Res> {
  __$RequestTicketInitCopyWithImpl(
      _RequestTicketInit _value, $Res Function(_RequestTicketInit) _then)
      : super(_value, (v) => _then(v as _RequestTicketInit));

  @override
  _RequestTicketInit get _value => super._value as _RequestTicketInit;
}

/// @nodoc

class _$_RequestTicketInit implements _RequestTicketInit {
  const _$_RequestTicketInit();

  @override
  String toString() {
    return 'RequestTicketState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _RequestTicketInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
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
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _RequestTicketInit implements RequestTicketState {
  const factory _RequestTicketInit() = _$_RequestTicketInit;
}

/// @nodoc
abstract class _$RequestTicketRequestingCopyWith<$Res> {
  factory _$RequestTicketRequestingCopyWith(_RequestTicketRequesting value,
          $Res Function(_RequestTicketRequesting) then) =
      __$RequestTicketRequestingCopyWithImpl<$Res>;
}

/// @nodoc
class __$RequestTicketRequestingCopyWithImpl<$Res>
    extends _$RequestTicketStateCopyWithImpl<$Res>
    implements _$RequestTicketRequestingCopyWith<$Res> {
  __$RequestTicketRequestingCopyWithImpl(_RequestTicketRequesting _value,
      $Res Function(_RequestTicketRequesting) _then)
      : super(_value, (v) => _then(v as _RequestTicketRequesting));

  @override
  _RequestTicketRequesting get _value =>
      super._value as _RequestTicketRequesting;
}

/// @nodoc

class _$_RequestTicketRequesting implements _RequestTicketRequesting {
  const _$_RequestTicketRequesting();

  @override
  String toString() {
    return 'RequestTicketState.requesting()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _RequestTicketRequesting);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) {
    return requesting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) {
    return requesting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
    required TResult orElse(),
  }) {
    if (requesting != null) {
      return requesting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) {
    return requesting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) {
    return requesting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) {
    if (requesting != null) {
      return requesting(this);
    }
    return orElse();
  }
}

abstract class _RequestTicketRequesting implements RequestTicketState {
  const factory _RequestTicketRequesting() = _$_RequestTicketRequesting;
}

/// @nodoc
abstract class _$RequestTicketRequestedCopyWith<$Res> {
  factory _$RequestTicketRequestedCopyWith(_RequestTicketRequested value,
          $Res Function(_RequestTicketRequested) then) =
      __$RequestTicketRequestedCopyWithImpl<$Res>;
  $Res call({String? txnId});
}

/// @nodoc
class __$RequestTicketRequestedCopyWithImpl<$Res>
    extends _$RequestTicketStateCopyWithImpl<$Res>
    implements _$RequestTicketRequestedCopyWith<$Res> {
  __$RequestTicketRequestedCopyWithImpl(_RequestTicketRequested _value,
      $Res Function(_RequestTicketRequested) _then)
      : super(_value, (v) => _then(v as _RequestTicketRequested));

  @override
  _RequestTicketRequested get _value => super._value as _RequestTicketRequested;

  @override
  $Res call({
    Object? txnId = freezed,
  }) {
    return _then(_RequestTicketRequested(
      txnId == freezed
          ? _value.txnId
          : txnId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_RequestTicketRequested implements _RequestTicketRequested {
  const _$_RequestTicketRequested(this.txnId);

  @override
  final String? txnId;

  @override
  String toString() {
    return 'RequestTicketState.requested(txnId: $txnId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RequestTicketRequested &&
            const DeepCollectionEquality().equals(other.txnId, txnId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(txnId));

  @JsonKey(ignore: true)
  @override
  _$RequestTicketRequestedCopyWith<_RequestTicketRequested> get copyWith =>
      __$RequestTicketRequestedCopyWithImpl<_RequestTicketRequested>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) {
    return requested(txnId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) {
    return requested?.call(txnId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
    required TResult orElse(),
  }) {
    if (requested != null) {
      return requested(txnId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) {
    return requested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) {
    return requested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) {
    if (requested != null) {
      return requested(this);
    }
    return orElse();
  }
}

abstract class _RequestTicketRequested implements RequestTicketState {
  const factory _RequestTicketRequested(String? txnId) =
      _$_RequestTicketRequested;

  String? get txnId;
  @JsonKey(ignore: true)
  _$RequestTicketRequestedCopyWith<_RequestTicketRequested> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$RequestTicketCancellingCopyWith<$Res> {
  factory _$RequestTicketCancellingCopyWith(_RequestTicketCancelling value,
          $Res Function(_RequestTicketCancelling) then) =
      __$RequestTicketCancellingCopyWithImpl<$Res>;
}

/// @nodoc
class __$RequestTicketCancellingCopyWithImpl<$Res>
    extends _$RequestTicketStateCopyWithImpl<$Res>
    implements _$RequestTicketCancellingCopyWith<$Res> {
  __$RequestTicketCancellingCopyWithImpl(_RequestTicketCancelling _value,
      $Res Function(_RequestTicketCancelling) _then)
      : super(_value, (v) => _then(v as _RequestTicketCancelling));

  @override
  _RequestTicketCancelling get _value =>
      super._value as _RequestTicketCancelling;
}

/// @nodoc

class _$_RequestTicketCancelling implements _RequestTicketCancelling {
  const _$_RequestTicketCancelling();

  @override
  String toString() {
    return 'RequestTicketState.cancelling()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _RequestTicketCancelling);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) {
    return cancelling();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) {
    return cancelling?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
    required TResult orElse(),
  }) {
    if (cancelling != null) {
      return cancelling();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) {
    return cancelling(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) {
    return cancelling?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) {
    if (cancelling != null) {
      return cancelling(this);
    }
    return orElse();
  }
}

abstract class _RequestTicketCancelling implements RequestTicketState {
  const factory _RequestTicketCancelling() = _$_RequestTicketCancelling;
}

/// @nodoc
abstract class _$RequestTicketCancelledCopyWith<$Res> {
  factory _$RequestTicketCancelledCopyWith(_RequestTicketCancelled value,
          $Res Function(_RequestTicketCancelled) then) =
      __$RequestTicketCancelledCopyWithImpl<$Res>;
  $Res call({String? txnId});
}

/// @nodoc
class __$RequestTicketCancelledCopyWithImpl<$Res>
    extends _$RequestTicketStateCopyWithImpl<$Res>
    implements _$RequestTicketCancelledCopyWith<$Res> {
  __$RequestTicketCancelledCopyWithImpl(_RequestTicketCancelled _value,
      $Res Function(_RequestTicketCancelled) _then)
      : super(_value, (v) => _then(v as _RequestTicketCancelled));

  @override
  _RequestTicketCancelled get _value => super._value as _RequestTicketCancelled;

  @override
  $Res call({
    Object? txnId = freezed,
  }) {
    return _then(_RequestTicketCancelled(
      txnId == freezed
          ? _value.txnId
          : txnId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_RequestTicketCancelled implements _RequestTicketCancelled {
  const _$_RequestTicketCancelled(this.txnId);

  @override
  final String? txnId;

  @override
  String toString() {
    return 'RequestTicketState.cancelled(txnId: $txnId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RequestTicketCancelled &&
            const DeepCollectionEquality().equals(other.txnId, txnId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(txnId));

  @JsonKey(ignore: true)
  @override
  _$RequestTicketCancelledCopyWith<_RequestTicketCancelled> get copyWith =>
      __$RequestTicketCancelledCopyWithImpl<_RequestTicketCancelled>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) {
    return cancelled(txnId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) {
    return cancelled?.call(txnId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(txnId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class _RequestTicketCancelled implements RequestTicketState {
  const factory _RequestTicketCancelled(String? txnId) =
      _$_RequestTicketCancelled;

  String? get txnId;
  @JsonKey(ignore: true)
  _$RequestTicketCancelledCopyWith<_RequestTicketCancelled> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$RequestTicketErrorCopyWith<$Res> {
  factory _$RequestTicketErrorCopyWith(
          _RequestTicketError value, $Res Function(_RequestTicketError) then) =
      __$RequestTicketErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$RequestTicketErrorCopyWithImpl<$Res>
    extends _$RequestTicketStateCopyWithImpl<$Res>
    implements _$RequestTicketErrorCopyWith<$Res> {
  __$RequestTicketErrorCopyWithImpl(
      _RequestTicketError _value, $Res Function(_RequestTicketError) _then)
      : super(_value, (v) => _then(v as _RequestTicketError));

  @override
  _RequestTicketError get _value => super._value as _RequestTicketError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_RequestTicketError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_RequestTicketError implements _RequestTicketError {
  const _$_RequestTicketError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'RequestTicketState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RequestTicketError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$RequestTicketErrorCopyWith<_RequestTicketError> get copyWith =>
      __$RequestTicketErrorCopyWithImpl<_RequestTicketError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
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
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _RequestTicketError implements RequestTicketState {
  const factory _RequestTicketError(String? message) = _$_RequestTicketError;

  String? get message;
  @JsonKey(ignore: true)
  _$RequestTicketErrorCopyWith<_RequestTicketError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$RequestTicketLoadingCopyWith<$Res> {
  factory _$RequestTicketLoadingCopyWith(_RequestTicketLoading value,
          $Res Function(_RequestTicketLoading) then) =
      __$RequestTicketLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$RequestTicketLoadingCopyWithImpl<$Res>
    extends _$RequestTicketStateCopyWithImpl<$Res>
    implements _$RequestTicketLoadingCopyWith<$Res> {
  __$RequestTicketLoadingCopyWithImpl(
      _RequestTicketLoading _value, $Res Function(_RequestTicketLoading) _then)
      : super(_value, (v) => _then(v as _RequestTicketLoading));

  @override
  _RequestTicketLoading get _value => super._value as _RequestTicketLoading;
}

/// @nodoc

class _$_RequestTicketLoading implements _RequestTicketLoading {
  const _$_RequestTicketLoading();

  @override
  String toString() {
    return 'RequestTicketState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _RequestTicketLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
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
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _RequestTicketLoading implements RequestTicketState {
  const factory _RequestTicketLoading() = _$_RequestTicketLoading;
}

/// @nodoc
abstract class _$RequestTicketSuccessCopyWith<$Res> {
  factory _$RequestTicketSuccessCopyWith(_RequestTicketSuccess value,
          $Res Function(_RequestTicketSuccess) then) =
      __$RequestTicketSuccessCopyWithImpl<$Res>;
  $Res call({String? tixId});
}

/// @nodoc
class __$RequestTicketSuccessCopyWithImpl<$Res>
    extends _$RequestTicketStateCopyWithImpl<$Res>
    implements _$RequestTicketSuccessCopyWith<$Res> {
  __$RequestTicketSuccessCopyWithImpl(
      _RequestTicketSuccess _value, $Res Function(_RequestTicketSuccess) _then)
      : super(_value, (v) => _then(v as _RequestTicketSuccess));

  @override
  _RequestTicketSuccess get _value => super._value as _RequestTicketSuccess;

  @override
  $Res call({
    Object? tixId = freezed,
  }) {
    return _then(_RequestTicketSuccess(
      tixId == freezed
          ? _value.tixId
          : tixId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_RequestTicketSuccess implements _RequestTicketSuccess {
  const _$_RequestTicketSuccess(this.tixId);

  @override
  final String? tixId;

  @override
  String toString() {
    return 'RequestTicketState.data(tixId: $tixId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RequestTicketSuccess &&
            const DeepCollectionEquality().equals(other.tixId, tixId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(tixId));

  @JsonKey(ignore: true)
  @override
  _$RequestTicketSuccessCopyWith<_RequestTicketSuccess> get copyWith =>
      __$RequestTicketSuccessCopyWithImpl<_RequestTicketSuccess>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() requesting,
    required TResult Function(String? txnId) requested,
    required TResult Function() cancelling,
    required TResult Function(String? txnId) cancelled,
    required TResult Function(String? message) error,
    required TResult Function() loading,
    required TResult Function(String? tixId) data,
  }) {
    return data(tixId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
  }) {
    return data?.call(tixId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? requesting,
    TResult Function(String? txnId)? requested,
    TResult Function()? cancelling,
    TResult Function(String? txnId)? cancelled,
    TResult Function(String? message)? error,
    TResult Function()? loading,
    TResult Function(String? tixId)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(tixId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RequestTicketInit value) init,
    required TResult Function(_RequestTicketRequesting value) requesting,
    required TResult Function(_RequestTicketRequested value) requested,
    required TResult Function(_RequestTicketCancelling value) cancelling,
    required TResult Function(_RequestTicketCancelled value) cancelled,
    required TResult Function(_RequestTicketError value) error,
    required TResult Function(_RequestTicketLoading value) loading,
    required TResult Function(_RequestTicketSuccess value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RequestTicketInit value)? init,
    TResult Function(_RequestTicketRequesting value)? requesting,
    TResult Function(_RequestTicketRequested value)? requested,
    TResult Function(_RequestTicketCancelling value)? cancelling,
    TResult Function(_RequestTicketCancelled value)? cancelled,
    TResult Function(_RequestTicketError value)? error,
    TResult Function(_RequestTicketLoading value)? loading,
    TResult Function(_RequestTicketSuccess value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _RequestTicketSuccess implements RequestTicketState {
  const factory _RequestTicketSuccess(String? tixId) = _$_RequestTicketSuccess;

  String? get tixId;
  @JsonKey(ignore: true)
  _$RequestTicketSuccessCopyWith<_RequestTicketSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
