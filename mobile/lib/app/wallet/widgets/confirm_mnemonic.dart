import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ride/app/wallet/widgets/wallet_setup_field.dart';
import 'package:ride/widgets/paper_form.dart';

class ConfirmMnemonic extends HookWidget {
  const ConfirmMnemonic({
    Key? key,
    this.onConfirm,
    this.onGenerateNew,
  }) : super(key: key);

  final Function(String)? onConfirm;
  final VoidCallback? onGenerateNew;

  @override
  Widget build(BuildContext context) {
    final mnemonicController = useTextEditingController();
    return Center(
      child: Container(
        margin: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: PaperForm(
            padding: 30,
            actionButtons: <Widget>[
              OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                child: const Text('Generate New'),
                onPressed: onGenerateNew,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
                child: const Text('Confirm'),
                onPressed: onConfirm != null
                    ? () => onConfirm!(mnemonicController.value.text)
                    : null,
              )
            ],
            children: <Widget>[
              WalletSetupField(
                label: 'Confirm your seed',
                hintText: 'Please type your seed phrase again',
                controller: mnemonicController,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
