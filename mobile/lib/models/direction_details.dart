import 'package:freezed_annotation/freezed_annotation.dart';

part 'direction_details.freezed.dart';

@freezed
class DirectionDetails with _$DirectionDetails {
  const factory DirectionDetails({
    required final String distanceText,
    required final String durationText,
    required final int distanceValue,
    required final int durationValue,
    required final String encodedPoints,
  }) = _DirectionDetails;
}
