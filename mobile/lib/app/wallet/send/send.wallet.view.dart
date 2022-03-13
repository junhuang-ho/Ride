import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/wallet/send/send.wallet.vm.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class SendWalletView extends HookConsumerWidget {
  const SendWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendWallet = ref.watch(sendWalletProvider);

    final qrcodeAddress = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send to'),
        actions: <Widget>[
          if (!kIsWeb)
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: sendWallet.maybeWhen(
                loading: null,
                orElse: () => () {
                  context.push(
                    '/qrcode_reader',
                    extra: (scannedAddress) {
                      qrcodeAddress.value = scannedAddress.toString();
                    },
                  );
                },
              ),
            ),
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
    final receiverController = useTextEditingController();
    final amountController = useTextEditingController();

    useEffect(() {
      if (address != null) {
        receiverController.value = TextEditingValue(text: address!);
      }
      return null;
    }, [address]);

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
