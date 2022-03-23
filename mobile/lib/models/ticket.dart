import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'ticket.freezed.dart';

@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    required final EthereumAddress passenger,
    required final EthereumAddress driver,
    required final BigInt badge,
    required final bool strict,
    required final BigInt metres,
    required final Uint8List keyLocal,
    required final Uint8List keyPay,
    required final BigInt cancellationFee,
    required final BigInt fare,
    required final bool tripStart,
    required final BigInt forceEndTimestamp,
  }) = _Ticket;

  static Ticket parseRaw(List<dynamic> rawResponse) {
    return Ticket(
      passenger: rawResponse[0],
      driver: rawResponse[1],
      badge: rawResponse[2],
      strict: rawResponse[3],
      metres: rawResponse[4],
      keyLocal: rawResponse[5],
      keyPay: rawResponse[6],
      cancellationFee: rawResponse[7],
      fare: rawResponse[8],
      tripStart: rawResponse[9],
      forceEndTimestamp: rawResponse[10],
    );
  }
}
