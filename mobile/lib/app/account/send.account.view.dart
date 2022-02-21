import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/account/send.account.vm.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class SendAccountView extends HookConsumerWidget {
  const SendAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendAccount = ref.watch(sendAccountProvider);

    final qrcodeAddress = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send to'),
        actions: <Widget>[
          if (!kIsWeb)
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: sendAccount.maybeWhen(
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
      body: sendAccount.maybeWhen(
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
    final sendAccount = ref.watch(sendAccountProvider);
    final receiverController = useTextEditingController();
    final amountController = useTextEditingController();

    useEffect(() {
      if (address != null) {
        receiverController.value = TextEditingValue(text: address!);
      }
    }, [address]);

    return Center(
      child: PaperForm(
        padding: 30,
        actionButtons: <Widget>[
          OutlinedButton(
            child: const Text('Send now'),
            onPressed: () async {
              await ref
                  .read(sendAccountProvider.notifier)
                  .sendWETHTo(receiverController.text, amountController.text);
            },
          ),
        ],
        children: <Widget>[
          sendAccount.when(
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
                  hintText: 'Please enter the amount',
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
