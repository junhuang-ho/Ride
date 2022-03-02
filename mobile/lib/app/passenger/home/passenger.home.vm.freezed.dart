// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'passenger.home.vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PassengerHomeStateTearOff {
  const _$PassengerHomeStateTearOff();

  _PassengerHomeStateInit init(MapState mapState) {
    return _PassengerHomeStateInit(
      mapState,
    );
  }

  _PassengerHomeStateUpdateDriversOnMap updateDriversOnMap(
      Set<Marker> markers) {
    return _PassengerHomeStateUpdateDriversOnMap(
      markers,
    );
  }

  _PassengerHomeLoading loading() {
    return const _PassengerHomeLoading();
  }

  _PassengerHomeError error(String? message) {
    return _PassengerHomeError(
      message,
    );
  }

  _PassengerHomeData data(Address address) {
    return _PassengerHomeData(
      address,
    );
  }
}

/// @nodoc
const $PassengerHomeState = _$PassengerHomeStateTearOff();

/// @nodoc
mixin _$PassengerHomeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MapState mapState) init,
    required TResult Function(Set<Marker> markers) updateDriversOnMap,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Address address) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerHomeStateInit value) init,
    required TResult Function(_PassengerHomeStateUpdateDriversOnMap value)
        updateDriversOnMap,
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassengerHomeStateCopyWith<$Res> {
  factory $PassengerHomeStateCopyWith(
          PassengerHomeState value, $Res Function(PassengerHomeState) then) =
      _$PassengerHomeStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$PassengerHomeStateCopyWithImpl<$Res>
    implements $PassengerHomeStateCopyWith<$Res> {
  _$PassengerHomeStateCopyWithImpl(this._value, this._then);

  final PassengerHomeState _value;
  // ignore: unused_field
  final $Res Function(PassengerHomeState) _then;
}

/// @nodoc
abstract class _$PassengerHomeStateInitCopyWith<$Res> {
  factory _$PassengerHomeStateInitCopyWith(_PassengerHomeStateInit value,
          $Res Function(_PassengerHomeStateInit) then) =
      __$PassengerHomeStateInitCopyWithImpl<$Res>;
  $Res call({MapState mapState});
}

/// @nodoc
class __$PassengerHomeStateInitCopyWithImpl<$Res>
    extends _$PassengerHomeStateCopyWithImpl<$Res>
    implements _$PassengerHomeStateInitCopyWith<$Res> {
  __$PassengerHomeStateInitCopyWithImpl(_PassengerHomeStateInit _value,
      $Res Function(_PassengerHomeStateInit) _then)
      : super(_value, (v) => _then(v as _PassengerHomeStateInit));

  @override
  _PassengerHomeStateInit get _value => super._value as _PassengerHomeStateInit;

  @override
  $Res call({
    Object? mapState = freezed,
  }) {
    return _then(_PassengerHomeStateInit(
      mapState == freezed
          ? _value.mapState
          : mapState // ignore: cast_nullable_to_non_nullable
              as MapState,
    ));
  }
}

/// @nodoc

class _$_PassengerHomeStateInit implements _PassengerHomeStateInit {
  const _$_PassengerHomeStateInit(this.mapState);

  @override
  final MapState mapState;

  @override
  String toString() {
    return 'PassengerHomeState.init(mapState: $mapState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerHomeStateInit &&
            const DeepCollectionEquality().equals(other.mapState, mapState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(mapState));

  @JsonKey(ignore: true)
  @override
  _$PassengerHomeStateInitCopyWith<_PassengerHomeStateInit> get copyWith =>
      __$PassengerHomeStateInitCopyWithImpl<_PassengerHomeStateInit>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MapState mapState) init,
    required TResult Function(Set<Marker> markers) updateDriversOnMap,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Address address) data,
  }) {
    return init(mapState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
  }) {
    return init?.call(mapState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(mapState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerHomeStateInit value) init,
    required TResult Function(_PassengerHomeStateUpdateDriversOnMap value)
        updateDriversOnMap,
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class _PassengerHomeStateInit implements PassengerHomeState {
  const factory _PassengerHomeStateInit(MapState mapState) =
      _$_PassengerHomeStateInit;

  MapState get mapState;
  @JsonKey(ignore: true)
  _$PassengerHomeStateInitCopyWith<_PassengerHomeStateInit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$PassengerHomeStateUpdateDriversOnMapCopyWith<$Res> {
  factory _$PassengerHomeStateUpdateDriversOnMapCopyWith(
          _PassengerHomeStateUpdateDriversOnMap value,
          $Res Function(_PassengerHomeStateUpdateDriversOnMap) then) =
      __$PassengerHomeStateUpdateDriversOnMapCopyWithImpl<$Res>;
  $Res call({Set<Marker> markers});
}

/// @nodoc
class __$PassengerHomeStateUpdateDriversOnMapCopyWithImpl<$Res>
    extends _$PassengerHomeStateCopyWithImpl<$Res>
    implements _$PassengerHomeStateUpdateDriversOnMapCopyWith<$Res> {
  __$PassengerHomeStateUpdateDriversOnMapCopyWithImpl(
      _PassengerHomeStateUpdateDriversOnMap _value,
      $Res Function(_PassengerHomeStateUpdateDriversOnMap) _then)
      : super(_value, (v) => _then(v as _PassengerHomeStateUpdateDriversOnMap));

  @override
  _PassengerHomeStateUpdateDriversOnMap get _value =>
      super._value as _PassengerHomeStateUpdateDriversOnMap;

  @override
  $Res call({
    Object? markers = freezed,
  }) {
    return _then(_PassengerHomeStateUpdateDriversOnMap(
      markers == freezed
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
    ));
  }
}

/// @nodoc

class _$_PassengerHomeStateUpdateDriversOnMap
    implements _PassengerHomeStateUpdateDriversOnMap {
  const _$_PassengerHomeStateUpdateDriversOnMap(this.markers);

  @override
  final Set<Marker> markers;

  @override
  String toString() {
    return 'PassengerHomeState.updateDriversOnMap(markers: $markers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerHomeStateUpdateDriversOnMap &&
            const DeepCollectionEquality().equals(other.markers, markers));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(markers));

  @JsonKey(ignore: true)
  @override
  _$PassengerHomeStateUpdateDriversOnMapCopyWith<
          _PassengerHomeStateUpdateDriversOnMap>
      get copyWith => __$PassengerHomeStateUpdateDriversOnMapCopyWithImpl<
          _PassengerHomeStateUpdateDriversOnMap>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MapState mapState) init,
    required TResult Function(Set<Marker> markers) updateDriversOnMap,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Address address) data,
  }) {
    return updateDriversOnMap(markers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
  }) {
    return updateDriversOnMap?.call(markers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
    required TResult orElse(),
  }) {
    if (updateDriversOnMap != null) {
      return updateDriversOnMap(markers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerHomeStateInit value) init,
    required TResult Function(_PassengerHomeStateUpdateDriversOnMap value)
        updateDriversOnMap,
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) {
    return updateDriversOnMap(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) {
    return updateDriversOnMap?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) {
    if (updateDriversOnMap != null) {
      return updateDriversOnMap(this);
    }
    return orElse();
  }
}

abstract class _PassengerHomeStateUpdateDriversOnMap
    implements PassengerHomeState {
  const factory _PassengerHomeStateUpdateDriversOnMap(Set<Marker> markers) =
      _$_PassengerHomeStateUpdateDriversOnMap;

  Set<Marker> get markers;
  @JsonKey(ignore: true)
  _$PassengerHomeStateUpdateDriversOnMapCopyWith<
          _PassengerHomeStateUpdateDriversOnMap>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$PassengerHomeLoadingCopyWith<$Res> {
  factory _$PassengerHomeLoadingCopyWith(_PassengerHomeLoading value,
          $Res Function(_PassengerHomeLoading) then) =
      __$PassengerHomeLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$PassengerHomeLoadingCopyWithImpl<$Res>
    extends _$PassengerHomeStateCopyWithImpl<$Res>
    implements _$PassengerHomeLoadingCopyWith<$Res> {
  __$PassengerHomeLoadingCopyWithImpl(
      _PassengerHomeLoading _value, $Res Function(_PassengerHomeLoading) _then)
      : super(_value, (v) => _then(v as _PassengerHomeLoading));

  @override
  _PassengerHomeLoading get _value => super._value as _PassengerHomeLoading;
}

/// @nodoc

class _$_PassengerHomeLoading implements _PassengerHomeLoading {
  const _$_PassengerHomeLoading();

  @override
  String toString() {
    return 'PassengerHomeState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _PassengerHomeLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MapState mapState) init,
    required TResult Function(Set<Marker> markers) updateDriversOnMap,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Address address) data,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
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
    required TResult Function(_PassengerHomeStateInit value) init,
    required TResult Function(_PassengerHomeStateUpdateDriversOnMap value)
        updateDriversOnMap,
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _PassengerHomeLoading implements PassengerHomeState {
  const factory _PassengerHomeLoading() = _$_PassengerHomeLoading;
}

/// @nodoc
abstract class _$PassengerHomeErrorCopyWith<$Res> {
  factory _$PassengerHomeErrorCopyWith(
          _PassengerHomeError value, $Res Function(_PassengerHomeError) then) =
      __$PassengerHomeErrorCopyWithImpl<$Res>;
  $Res call({String? message});
}

/// @nodoc
class __$PassengerHomeErrorCopyWithImpl<$Res>
    extends _$PassengerHomeStateCopyWithImpl<$Res>
    implements _$PassengerHomeErrorCopyWith<$Res> {
  __$PassengerHomeErrorCopyWithImpl(
      _PassengerHomeError _value, $Res Function(_PassengerHomeError) _then)
      : super(_value, (v) => _then(v as _PassengerHomeError));

  @override
  _PassengerHomeError get _value => super._value as _PassengerHomeError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_PassengerHomeError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_PassengerHomeError implements _PassengerHomeError {
  const _$_PassengerHomeError(this.message);

  @override
  final String? message;

  @override
  String toString() {
    return 'PassengerHomeState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerHomeError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$PassengerHomeErrorCopyWith<_PassengerHomeError> get copyWith =>
      __$PassengerHomeErrorCopyWithImpl<_PassengerHomeError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MapState mapState) init,
    required TResult Function(Set<Marker> markers) updateDriversOnMap,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Address address) data,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
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
    required TResult Function(_PassengerHomeStateInit value) init,
    required TResult Function(_PassengerHomeStateUpdateDriversOnMap value)
        updateDriversOnMap,
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _PassengerHomeError implements PassengerHomeState {
  const factory _PassengerHomeError(String? message) = _$_PassengerHomeError;

  String? get message;
  @JsonKey(ignore: true)
  _$PassengerHomeErrorCopyWith<_PassengerHomeError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$PassengerHomeDataCopyWith<$Res> {
  factory _$PassengerHomeDataCopyWith(
          _PassengerHomeData value, $Res Function(_PassengerHomeData) then) =
      __$PassengerHomeDataCopyWithImpl<$Res>;
  $Res call({Address address});

  $AddressCopyWith<$Res> get address;
}

/// @nodoc
class __$PassengerHomeDataCopyWithImpl<$Res>
    extends _$PassengerHomeStateCopyWithImpl<$Res>
    implements _$PassengerHomeDataCopyWith<$Res> {
  __$PassengerHomeDataCopyWithImpl(
      _PassengerHomeData _value, $Res Function(_PassengerHomeData) _then)
      : super(_value, (v) => _then(v as _PassengerHomeData));

  @override
  _PassengerHomeData get _value => super._value as _PassengerHomeData;

  @override
  $Res call({
    Object? address = freezed,
  }) {
    return _then(_PassengerHomeData(
      address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address,
    ));
  }

  @override
  $AddressCopyWith<$Res> get address {
    return $AddressCopyWith<$Res>(_value.address, (value) {
      return _then(_value.copyWith(address: value));
    });
  }
}

/// @nodoc

class _$_PassengerHomeData implements _PassengerHomeData {
  const _$_PassengerHomeData(this.address);

  @override
  final Address address;

  @override
  String toString() {
    return 'PassengerHomeState.data(address: $address)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PassengerHomeData &&
            const DeepCollectionEquality().equals(other.address, address));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(address));

  @JsonKey(ignore: true)
  @override
  _$PassengerHomeDataCopyWith<_PassengerHomeData> get copyWith =>
      __$PassengerHomeDataCopyWithImpl<_PassengerHomeData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MapState mapState) init,
    required TResult Function(Set<Marker> markers) updateDriversOnMap,
    required TResult Function() loading,
    required TResult Function(String? message) error,
    required TResult Function(Address address) data,
  }) {
    return data(address);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
  }) {
    return data?.call(address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MapState mapState)? init,
    TResult Function(Set<Marker> markers)? updateDriversOnMap,
    TResult Function()? loading,
    TResult Function(String? message)? error,
    TResult Function(Address address)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(address);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PassengerHomeStateInit value) init,
    required TResult Function(_PassengerHomeStateUpdateDriversOnMap value)
        updateDriversOnMap,
    required TResult Function(_PassengerHomeLoading value) loading,
    required TResult Function(_PassengerHomeError value) error,
    required TResult Function(_PassengerHomeData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PassengerHomeStateInit value)? init,
    TResult Function(_PassengerHomeStateUpdateDriversOnMap value)?
        updateDriversOnMap,
    TResult Function(_PassengerHomeLoading value)? loading,
    TResult Function(_PassengerHomeError value)? error,
    TResult Function(_PassengerHomeData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _PassengerHomeData implements PassengerHomeState {
  const factory _PassengerHomeData(Address address) = _$_PassengerHomeData;

  Address get address;
  @JsonKey(ignore: true)
  _$PassengerHomeDataCopyWith<_PassengerHomeData> get copyWith =>
      throw _privateConstructorUsedError;
}
