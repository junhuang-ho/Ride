import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:ride/utils/eth_amount_formatter.dart';

class AccountDropdown extends StatelessWidget {
  const AccountDropdown({
    Key? key,
    required this.name,
    required this.publicAddress,
    required this.balance,
    required this.symbol,
  }) : super(key: key);

  final String name;
  final String publicAddress;
  final BigInt balance;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: FormBuilderDropdown(
        isDense: false,
        itemHeight: 55,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
          labelStyle: const TextStyle(fontSize: 16.0),
          errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        name: name,
        items: [
          DropdownMenuItem(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: SvgPicture.string(Jdenticon.toSvg(publicAddress)),
                    radius: 15,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Account 1'),
                    Text(
                      'Balance: ${EthAmountFormatter(balance).format()} $symbol',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
