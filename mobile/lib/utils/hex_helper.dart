import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:ride/utils/constants.dart';

class HexHelper {
  static bool isAllZeroIn64Hex(Uint8List value) {
    final encodedValue = HEX.encode(value);
    return encodedValue == Strings.allZeroIn64Hex;
  }
}
