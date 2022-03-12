import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            OutlinedButton(
              child: const Text('Register'),
              onPressed: () async {
                await ref
                    .read(registerDriverProvider.notifier)
                    .registerAsDriver(registerDriverController.text);
              },
            ),
            // OutlinedButton(
            //   child: const Text('Update'),
            //   onPressed: () async {
            //     await ref
            //         .read(registerDriverProvider.notifier)
            //         .updateMaxMetresPerTrip(registerDriverController.text);
            //   },
            // ),
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
              success: (data) => Text('Sucessfully registered $data!!!'),
            ),
          ],
        ),
      ),
    );
  }
}
