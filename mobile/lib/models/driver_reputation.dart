import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_reputation.freezed.dart';

@freezed
class DriverReputation with _$DriverReputation {
  const factory DriverReputation({
    required final BigInt id,
    required final String? uri,
    required final BigInt maxMetresPerTrip,
    required final BigInt metresTravelled,
    required final BigInt countStart,
    required final BigInt countEnd,
    required final BigInt totalRating,
    required final BigInt countRating,
  }) = _DriverReputation;

  static DriverReputation parseRaw(List<dynamic> rawResponse) {
    return DriverReputation(
      id: rawResponse[0],
      uri: rawResponse[1],
      maxMetresPerTrip: rawResponse[2],
      metresTravelled: rawResponse[3],
      countStart: rawResponse[4],
      countEnd: rawResponse[5],
      totalRating: rawResponse[6],
      countRating: rawResponse[7],
    );
  }
}
