import 'package:web3dart/web3dart.dart';

class EthAmountFormatter {
  EthAmountFormatter(this.amount);

  final BigInt? amount;
  String format({
    EtherUnit fromUnit = EtherUnit.wei,
    EtherUnit toUnit = EtherUnit.ether,
  }) {
    if (amount == null) {
      return '-';
    }

    return EtherAmount.fromUnitAndValue(fromUnit, amount)
        .getValueInUnit(toUnit)
        .toString();
  }

  String formatFiat({
    EtherUnit fromUnit = EtherUnit.wei,
    EtherUnit toUnit = EtherUnit.ether,
    int decimalPoint = 2,
  }) {
    if (amount == null) {
      return '-';
    }

    return EtherAmount.fromUnitAndValue(fromUnit, amount)
        .getValueInUnit(toUnit)
        .toStringAsFixed(decimalPoint);
  }
}
