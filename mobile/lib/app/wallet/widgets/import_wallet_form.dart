import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/wallet/setup.wallet.vm.dart';
import 'package:ride/app/wallet/widgets/wallet_setup_field.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_radio.dart';

class ImportWalletForm extends HookConsumerWidget {
  const ImportWalletForm({
    Key? key,
    this.onImport,
  }) : super(key: key);

  final Function(WalletImportType type, String value)? onImport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importType = useState(WalletImportType.mnemonic);
    final inputController = useTextEditingController();

    return Center(
      child: Container(
        margin: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: PaperForm(
            padding: 30,
            actionButtons: <Widget>[
              ElevatedButton(
                child: const Text('Import'),
                onPressed: onImport != null
                    ? () =>
                        onImport!(importType.value, inputController.value.text)
                    : null,
              )
            ],
            children: <Widget>[
              Row(
                children: <Widget>[
                  PaperRadio(
                    'Seed',
                    groupValue: importType.value,
                    value: WalletImportType.mnemonic,
                    onChanged: (value) =>
                        importType.value = value as WalletImportType,
                  ),
                  PaperRadio(
                    'Private Key',
                    groupValue: importType.value,
                    value: WalletImportType.privateKey,
                    onChanged: (value) =>
                        importType.value = value as WalletImportType,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Visibility(
                    child: WalletSetupField(
                      label: 'Private Key',
                      hintText: 'Type your private key',
                      controller: inputController,
                    ),
                    visible: importType.value == WalletImportType.privateKey,
                  ),
                  Visibility(
                    child: WalletSetupField(
                      label: 'Seed phrase',
                      hintText: 'Type your seed phrase',
                      controller: inputController,
                    ),
                    visible: importType.value == WalletImportType.mnemonic,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
