import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/driver/register/register.driver.vm.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class RegisterDriverView extends HookConsumerWidget {
  const RegisterDriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerDriver = ref.watch(registerDriverProvider);
    final registerDriverController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Registration'),
        automaticallyImplyLeading: registerDriver.maybeWhen(
          success: (_) => false,
          orElse: () => true,
        ),
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            registerDriver.maybeWhen(
              success: (_) => const SizedBox(),
              orElse: () => OutlinedButton(
                child: const Text('Register'),
                onPressed: () async {
                  await ref
                      .read(registerDriverProvider.notifier)
                      .registerAsDriver(registerDriverController.text);
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
              ),
              loading: () => const CircularProgressIndicator(),
              error: (message) => PaperValidationSummary([message!]),
              success: (data) => const RegisteredSuccessfulContent(),
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
