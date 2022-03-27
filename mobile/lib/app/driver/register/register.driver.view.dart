import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/driver/register/register.driver.vm.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/ride/ride_driver_registry.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';
import 'package:ride/widgets/pending_transaction.dart';

class RegisterDriverView extends HookConsumerWidget {
  const RegisterDriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerDriver = ref.watch(registerDriverProvider);
    final registerDriverController = useTextEditingController();

    Future<void> _registerAsDriver() async {
      await ref
          .read(registerDriverProvider.notifier)
          .registerAsDriver(registerDriverController.text);
      final userAddress = await ref.read(cryptoProvider).getUserPublicAddress();
      ref
          .read(rideDriverRegistryProvider)
          .rideDriverRegistry
          .registeredAsDriverEvents()
          .listen((event) {
        if (event.sender == userAddress) {
          ref.read(registerDriverProvider.notifier).goToSuccess();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Registration'),
        automaticallyImplyLeading: registerDriver.maybeWhen(
          success: () => false,
          orElse: () => true,
        ),
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            registerDriver.maybeWhen(
              success: () => const SizedBox(),
              orElse: () => OutlinedButton(
                child: const Text('Register'),
                onPressed: () async {
                  await _registerAsDriver();
                },
              ),
            ),
          ],
          children: <Widget>[
            registerDriver.when(
              init: () => PaperInput(
                labelText: "Max Metres Per Trip",
                hintText: 'Please type in max metres per trip',
                maxLines: 1,
                controller: registerDriverController,
                keyboardType: TextInputType.number,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (message) => PaperValidationSummary([message!]),
              pendingTransaction: () => const PendingTransaction(),
              success: () => const RegisteredSuccessfulContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisteredSuccessfulContent extends HookConsumerWidget {
  const RegisteredSuccessfulContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return Column(
      children: [
        const Text('Sucessfully registered as Driver !!!'),
        const Text('Begin Your Driver Journey!!!'),
        const SizedBox(height: 15),
        MaterialButton(
          height: 55,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: auth.maybeWhen(
              loading: () => const CircularProgressIndicator(),
              orElse: () => const Text('Begin Now'),
            ),
          ),
          onPressed: () async {
            await ref.read(authProvider.notifier).getAccount();
            context.go('/');
          },
        ),
      ],
    );
  }
}
