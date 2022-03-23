import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'direction_details.freezed.dart';

@freezed
class DirectionDetails with _$DirectionDetails {
  const factory DirectionDetails({
    required final String startAddress,
    required final LatLng startLocation,
    required final String endAddress,
    required final LatLng endLocation,
    required final String distanceText,
    required final String durationText,
    required final int distanceValue,
    required final int durationValue,
    required final String encodedPoints,
  }) = _DirectionDetails;
}
