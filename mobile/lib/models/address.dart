import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';

@freezed
class Address with _$Address {
  const factory Address({
    required final String placeName,
    final String? placeId,
    required final double latitude,
    required final double longitude,
  }) = _Address;
}
