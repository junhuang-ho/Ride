import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/wallet/send/send.wallet.vm.dart';
import 'package:ride/app/wallet/wallet.vm.dart';
import 'package:ride/app/wallet/widgets/account_dropdown.dart';
import 'package:ride/app/wallet/widgets/wallet_app_bar.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';
import 'package:ride/widgets/ride_text_field.dart';

class NewSendWalletView extends HookConsumerWidget {
  const NewSendWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendWallet = ref.watch(sendWalletProvider);

    final qrcodeAddress = useState('');

    return Scaffold(
      appBar: WalletAppBar(
        automaticallyImplyLeading: false,
        appBarTitle: 'Send to',
        actionWidgets: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => context.pop(),
          )
        ],
      ),
      body: sendWallet.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator()),
        orElse: () => SendForm(
          address: qrcodeAddress.value,
          onSubmit: (address, amount) async {},
        ),
      ),
    );
  }
}

class SendForm extends HookConsumerWidget {
  const SendForm({
    Key? key,
    required this.address,
    required this.onSubmit,
  }) : super(key: key);

  final String? address;
  final void Function(String address, String amount) onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendWallet = ref.watch(sendWalletProvider);
    final auth = ref.watch(authProvider);
    final wallet = ref.watch(walletProvider);
    final receiverController = useTextEditingController();
    final amountController = useTextEditingController();

    useEffect(() {
      if (address != null) {
        receiverController.value = TextEditingValue(text: address!);
      }
      return null;
    }, [address]);

    return Center(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'From: ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  AccountDropdown(
                    name: 'from',
                    publicAddress: auth.maybeWhen(
                        authenticated: (accountData) => accountData.publicKey,
                        orElse: () => ''),
                    balance: wallet.maybeWhen(
                        data: (walletData) => walletData.wETHBalance,
                        orElse: () => BigInt.zero),
                    symbol: 'WETH',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'To: ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 10),
                  RideTextField(
                    width: 300,
                    name: 'to',
                    readOnly: true,
                    label: 'Your Driver ID',
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Center(
      child: PaperForm(
        padding: 30,
        actionButtons: <Widget>[
          OutlinedButton(
            child: const Text('Send now'),
            onPressed: () async {
              await ref
                  .read(sendWalletProvider.notifier)
                  .sendWETHTo(receiverController.text, amountController.text);
            },
          ),
        ],
        children: <Widget>[
          sendWallet.when(
            init: () => Column(
              children: [
                PaperInput(
                  labelText: "Send WETH To",
                  hintText: 'Receiver Public Address',
                  maxLines: 1,
                  controller: receiverController,
                ),
                PaperInput(
                  labelText: "Amount",
                  hintText: 'Please enter the amount in ether',
                  maxLines: 1,
                  controller: amountController,
                ),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            error: (message) => PaperValidationSummary([message!]),
            success: (data) => Text('Sucessfully sent $data!!!'),
          ),
        ],
      ),
    );
  }
}
