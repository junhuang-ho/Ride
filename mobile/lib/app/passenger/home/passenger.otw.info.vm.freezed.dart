// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'passenger.otw.info.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PassengerOnTheWayInputTearOff {
  const _$PassengerOnTheWayInputTearOff();

  _PassengerOnTheWayInput call(
      {required String driverAddress, required String tixId}) {
    return _PassengerOnTheWayInput(
      driverAddress: driverAddress,
      tixId: tixId,
    );
  }
}

/// @nodoc
const $PassengerOnTheWayInput = _$PassengerOnTheWayInputTearOff();

/// @nodoc
mixin _$PassengerOnTheWayInput {
  String get driverAddress => throw _privateConstructorUsedError;
  String get tixId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PassengerOnTheWayInputCopyWith<PassengerOnTheWayInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassengerOnTheWayInputCopyWith<$Res> {
  factory $PassengerOnTheWayInputCopyWith(PassengerOnTheWayInput value,
          $Res Function(PassengerOnTheWayInput) then) =
      _$PassengerOnTheWayInputCopyWithImpl<$Res>;
  $Res call({String driverAddress, String tixId});
}

/// @nodoc
class _$PassengerOnTheWayInputCopyWithImpl<$Res>
    implements $PassengerOnTheWayInputCopyWith<$Res> {
  _$PassengerOnTheWayInputCopyWithImpl(this._value, this._then);

  final PassengerOnTheWayInput _value;
  // ignore: unused_field
  final $Res Function(PassengerOnTheWayInput) _then;

  @override
  $Res call({
    Object? driverAddress = freezed,
    Object? tixId = freezed,
  }) {
    return _then(_value.copyWith(
      driverAddress: driverAddress == freezed
          ? _value.driverAddress
          : driverAddress // ignore: cast_nullable_to_non_nullable
              as String,
      tixId: tixId == freezed
          ? _value.tixId
          : tixId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$PassengerOnTheWayInputCopyWith<$Res>
    implements $PassengerOnTheWayInputCopyWith<$Res> {
  factory _$PassengerOnTheWayInputCopyWith(_PassengerOnTheWayInput value,
          $Res Function(_PassengerOnTheWayInput) then) =
      __$PassengerOnTheWayInputCopyWithImpl<$Res>;
  @override
  $Res call({String driverAddress, String tixId});
}

/// @nodoc
class __$PassengerOnTheWayInputCopyWithImpl<$Res>
    extends _$PassengerOnTheWayInputCopyWithImpl<$Res>
    implements _$PassengerOnTheWayInputCopyWith<$Res> {
  __$PassengerOnTheWayInputCopyWithImpl(_PassengerOnTheWayInput _value,
      $Res Function(_PassengerOnTheWayInput) _then)
      : super(_value, (v) => _then(v as _PassengerOnTheWayInput));

  @override
  _PassengerOnTheWayInput get _value => super._value as _PassengerOnTheWayInput;

  @override
  $Res call({
    Object? driverAddress = freezed,
    Object? tixId = freezed,
  }) {
    return _then(_PassengerOnTheWayInput(
      driverAddress: driverAddress == freezed
          ? _value.driverAddress
          : driverAddress // ignore: cast_nullable_to_non_nullable
              as String,
      tixId: tixId == freezed
          ? _value.tixId
          : tixId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PassengerOnTheWayInput implements _PassengerOnTheWayInput {
  const _$_PassengerOnTheWayInput(
      {required this.driverAddress, required this.tixId});

  @override
  final String driverAddress;
  @override
  final String tixId;

  @override
  String toString() {
    return 'PassengerOnTheWayInput(driverAddress: $driverAddress, tixId: $tixId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerOnTheWayInput &&
            const DeepCollectionEquality()
                .equals(other.driverAddress, driverAddress) &&
            const DeepCollectionEquality().equals(other.tixId, tixId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(driverAddress),
      const DeepCollectionEquality().hash(tixId));

  @JsonKey(ignore: true)
  @override
  _$PassengerOnTheWayInputCopyWith<_PassengerOnTheWayInput> get copyWith =>
      __$PassengerOnTheWayInputCopyWithImpl<_PassengerOnTheWayInput>(
          this, _$identity);
}

abstract class _PassengerOnTheWayInput implements PassengerOnTheWayInput {
  const factory _PassengerOnTheWayInput(
      {required String driverAddress,
      required String tixId}) = _$_PassengerOnTheWayInput;

  @override
  String get driverAddress;
  @override
  String get tixId;
  @override
  @JsonKey(ignore: true)
  _$PassengerOnTheWayInputCopyWith<_PassengerOnTheWayInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$PassengerOnTheWayInfoStateTearOff {
  const _$PassengerOnTheWayInfoStateTearOff();

  _PassengerOnTheWayInfoError error(String? message) {
    return _PassengerOnTheWayInfoError(
      message,
    );
  }

  _PassengerOnTheWayInfoInit init() {
    return const _PassengerOnTheWayInfoInit();
  }

  _PassengerOnTheWayInfoLoading loading() {
    return const _PassengerOnTheWayInfoLoading();
  }

  _PassengerOnTheWayInfoData data(
      DriverReputation driverReputation, Ticket ticket) {
    return _PassengerOnTheWayInfoData(
      driverReputation,
      ticket,
    );
  }
}

/// @nodoc
const $PassengerOnTheWayInfoState = _$PassengerOnTheWayInfoStateTearOff();

/// @nodoc
mixin _$PassengerOnTheWayInfoState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(DriverReputation driverReputation, Ticket ticket)
        data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerOnTheWayInfoError value) error,
    required TResult Function(_PassengerOnTheWayInfoInit value) init,
    required TResult Function(_PassengerOnTheWayInfoLoading value) loading,
    required TResult Function(_PassengerOnTheWayInfoData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassengerOnTheWayInfoStateCopyWith<$Res> {
  factory $PassengerOnTheWayInfoStateCopyWith(PassengerOnTheWayInfoState value,
          $Res Function(PassengerOnTheWayInfoState) then) =
      _$PassengerOnTheWayInfoStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$PassengerOnTheWayInfoStateCopyWithImpl<$Res>
    implements $PassengerOnTheWayInfoStateCopyWith<$Res> {
  _$PassengerOnTheWayInfoStateCopyWithImpl(this._value, this._then);

  final PassengerOnTheWayInfoState _value;
  // ignore: unused_field
  final $Res Function(PassengerOnTheWayInfoState) _then;
}

/// @nodoc
abstract class _$PassengerOnTheWayInfoErrorCopyWith<$Res> {
  factory _$PassengerOnTheWayInfoErrorCopyWith(
          _PassengerOnTheWayInfoError value,
          $Res Function(_PassengerOnTheWayInfoError) then) =
      __$PassengerOnTheWayInfoErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$PassengerOnTheWayInfoErrorCopyWithImpl<$Res>
    extends _$PassengerOnTheWayInfoStateCopyWithImpl<$Res>
    implements _$PassengerOnTheWayInfoErrorCopyWith<$Res> {
  __$PassengerOnTheWayInfoErrorCopyWithImpl(_PassengerOnTheWayInfoError _value,
      $Res Function(_PassengerOnTheWayInfoError) _then)
      : super(_value, (v) => _then(v as _PassengerOnTheWayInfoError));

  @override
  _PassengerOnTheWayInfoError get _value =>
      super._value as _PassengerOnTheWayInfoError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_PassengerOnTheWayInfoError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_PassengerOnTheWayInfoError implements _PassengerOnTheWayInfoError {
  const _$_PassengerOnTheWayInfoError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'PassengerOnTheWayInfoState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerOnTheWayInfoError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$PassengerOnTheWayInfoErrorCopyWith<_PassengerOnTheWayInfoError>
      get copyWith => __$PassengerOnTheWayInfoErrorCopyWithImpl<
          _PassengerOnTheWayInfoError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(DriverReputation driverReputation, Ticket ticket)
        data,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
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
    required TResult Function(_PassengerOnTheWayInfoError value) error,
    required TResult Function(_PassengerOnTheWayInfoInit value) init,
    required TResult Function(_PassengerOnTheWayInfoLoading value) loading,
    required TResult Function(_PassengerOnTheWayInfoData value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _PassengerOnTheWayInfoError
    implements PassengerOnTheWayInfoState {
  const factory _PassengerOnTheWayInfoError(String? message) =
      _$_PassengerOnTheWayInfoError;

  String? get message;
  @JsonKey(ignore: true)
  _$PassengerOnTheWayInfoErrorCopyWith<_PassengerOnTheWayInfoError>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$PassengerOnTheWayInfoInitCopyWith<$Res> {
  factory _$PassengerOnTheWayInfoInitCopyWith(_PassengerOnTheWayInfoInit value,
          $Res Function(_PassengerOnTheWayInfoInit) then) =
      __$PassengerOnTheWayInfoInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$PassengerOnTheWayInfoInitCopyWithImpl<$Res>
    extends _$PassengerOnTheWayInfoStateCopyWithImpl<$Res>
    implements _$PassengerOnTheWayInfoInitCopyWith<$Res> {
  __$PassengerOnTheWayInfoInitCopyWithImpl(_PassengerOnTheWayInfoInit _value,
      $Res Function(_PassengerOnTheWayInfoInit) _then)
      : super(_value, (v) => _then(v as _PassengerOnTheWayInfoInit));

  @override
  _PassengerOnTheWayInfoInit get _value =>
      super._value as _PassengerOnTheWayInfoInit;
}

/// @nodoc

class _$_PassengerOnTheWayInfoInit implements _PassengerOnTheWayInfoInit {
  const _$_PassengerOnTheWayInfoInit();

  @override
  String toString() {
    return 'PassengerOnTheWayInfoState.init()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerOnTheWayInfoInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(DriverReputation driverReputation, Ticket ticket)
        data,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
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
    required TResult Function(_PassengerOnTheWayInfoError value) error,
    required TResult Function(_PassengerOnTheWayInfoInit value) init,
    required TResult Function(_PassengerOnTheWayInfoLoading value) loading,
    required TResult Function(_PassengerOnTheWayInfoData value) data,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _PassengerOnTheWayInfoInit
    implements PassengerOnTheWayInfoState {
  const factory _PassengerOnTheWayInfoInit() = _$_PassengerOnTheWayInfoInit;
}

/// @nodoc
abstract class _$PassengerOnTheWayInfoLoadingCopyWith<$Res> {
  factory _$PassengerOnTheWayInfoLoadingCopyWith(
          _PassengerOnTheWayInfoLoading value,
          $Res Function(_PassengerOnTheWayInfoLoading) then) =
      __$PassengerOnTheWayInfoLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$PassengerOnTheWayInfoLoadingCopyWithImpl<$Res>
    extends _$PassengerOnTheWayInfoStateCopyWithImpl<$Res>
    implements _$PassengerOnTheWayInfoLoadingCopyWith<$Res> {
  __$PassengerOnTheWayInfoLoadingCopyWithImpl(
      _PassengerOnTheWayInfoLoading _value,
      $Res Function(_PassengerOnTheWayInfoLoading) _then)
      : super(_value, (v) => _then(v as _PassengerOnTheWayInfoLoading));

  @override
  _PassengerOnTheWayInfoLoading get _value =>
      super._value as _PassengerOnTheWayInfoLoading;
}

/// @nodoc

class _$_PassengerOnTheWayInfoLoading implements _PassengerOnTheWayInfoLoading {
  const _$_PassengerOnTheWayInfoLoading();

  @override
  String toString() {
    return 'PassengerOnTheWayInfoState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerOnTheWayInfoLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(DriverReputation driverReputation, Ticket ticket)
        data,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
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
    required TResult Function(_PassengerOnTheWayInfoError value) error,
    required TResult Function(_PassengerOnTheWayInfoInit value) init,
    required TResult Function(_PassengerOnTheWayInfoLoading value) loading,
    required TResult Function(_PassengerOnTheWayInfoData value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _PassengerOnTheWayInfoLoading
    implements PassengerOnTheWayInfoState {
  const factory _PassengerOnTheWayInfoLoading() =
      _$_PassengerOnTheWayInfoLoading;
}

/// @nodoc
abstract class _$PassengerOnTheWayInfoDataCopyWith<$Res> {
  factory _$PassengerOnTheWayInfoDataCopyWith(_PassengerOnTheWayInfoData value,
          $Res Function(_PassengerOnTheWayInfoData) then) =
      __$PassengerOnTheWayInfoDataCopyWithImpl<$Res>;
  $Res call({DriverReputation driverReputation, Ticket ticket});

  $DriverReputationCopyWith<$Res> get driverReputation;
  $TicketCopyWith<$Res> get ticket;
}

/// @nodoc
class __$PassengerOnTheWayInfoDataCopyWithImpl<$Res>
    extends _$PassengerOnTheWayInfoStateCopyWithImpl<$Res>
    implements _$PassengerOnTheWayInfoDataCopyWith<$Res> {
  __$PassengerOnTheWayInfoDataCopyWithImpl(_PassengerOnTheWayInfoData _value,
      $Res Function(_PassengerOnTheWayInfoData) _then)
      : super(_value, (v) => _then(v as _PassengerOnTheWayInfoData));

  @override
  _PassengerOnTheWayInfoData get _value =>
      super._value as _PassengerOnTheWayInfoData;

  @override
  $Res call({
    Object? driverReputation = freezed,
    Object? ticket = freezed,
  }) {
    return _then(_PassengerOnTheWayInfoData(
      driverReputation == freezed
          ? _value.driverReputation
          : driverReputation // ignore: cast_nullable_to_non_nullable
              as DriverReputation,
      ticket == freezed
          ? _value.ticket
          : ticket // ignore: cast_nullable_to_non_nullable
              as Ticket,
    ));
  }

  @override
  $DriverReputationCopyWith<$Res> get driverReputation {
    return $DriverReputationCopyWith<$Res>(_value.driverReputation, (value) {
      return _then(_value.copyWith(driverReputation: value));
    });
  }

  @override
  $TicketCopyWith<$Res> get ticket {
    return $TicketCopyWith<$Res>(_value.ticket, (value) {
      return _then(_value.copyWith(ticket: value));
    });
  }
}

/// @nodoc

class _$_PassengerOnTheWayInfoData implements _PassengerOnTheWayInfoData {
  const _$_PassengerOnTheWayInfoData(this.driverReputation, this.ticket);

  @override
  final DriverReputation driverReputation;
  @override
  final Ticket ticket;

  @override
  String toString() {
    return 'PassengerOnTheWayInfoState.data(driverReputation: $driverReputation, ticket: $ticket)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerOnTheWayInfoData &&
            const DeepCollectionEquality()
                .equals(other.driverReputation, driverReputation) &&
            const DeepCollectionEquality().equals(other.ticket, ticket));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(driverReputation),
      const DeepCollectionEquality().hash(ticket));

  @JsonKey(ignore: true)
  @override
  _$PassengerOnTheWayInfoDataCopyWith<_PassengerOnTheWayInfoData>
      get copyWith =>
          __$PassengerOnTheWayInfoDataCopyWithImpl<_PassengerOnTheWayInfoData>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) error,
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(DriverReputation driverReputation, Ticket ticket)
        data,
  }) {
    return data(driverReputation, ticket);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
  }) {
    return data?.call(driverReputation, ticket);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? error,
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(DriverReputation driverReputation, Ticket ticket)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(driverReputation, ticket);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerOnTheWayInfoError value) error,
    required TResult Function(_PassengerOnTheWayInfoInit value) init,
    required TResult Function(_PassengerOnTheWayInfoLoading value) loading,
    required TResult Function(_PassengerOnTheWayInfoData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerOnTheWayInfoError value)? error,
    TResult Function(_PassengerOnTheWayInfoInit value)? init,
    TResult Function(_PassengerOnTheWayInfoLoading value)? loading,
    TResult Function(_PassengerOnTheWayInfoData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _PassengerOnTheWayInfoData
    implements PassengerOnTheWayInfoState {
  const factory _PassengerOnTheWayInfoData(
          DriverReputation driverReputation, Ticket ticket) =
      _$_PassengerOnTheWayInfoData;

  DriverReputation get driverReputation;
  Ticket get ticket;
  @JsonKey(ignore: true)
  _$PassengerOnTheWayInfoDataCopyWith<_PassengerOnTheWayInfoData>
      get copyWith => throw _privateConstructorUsedError;
}
