import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/profile/update.driver.vm.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class UpdateDriverView extends HookConsumerWidget {
  const UpdateDriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateDriver = ref.watch(updateDriverProvider);
    final updateDriverController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            OutlinedButton(
              child: const Text('Update'),
              onPressed: () async {
                await ref
                    .read(updateDriverProvider.notifier)
                    .updateMaxMetresPerTrip(updateDriverController.text);
              },
            ),
          ],
          children: <Widget>[
            updateDriver.when(
              init: () => PaperInput(
                labelText: "Max Metres Per Trip",
                hintText: 'Please type in max metres per trip',
                maxLines: 1,
                controller: updateDriverController,
              ),
              loading: () => const CircularProgressIndicator(),
              error: (message) => PaperValidationSummary([message!]),
              success: (data) => Text('Sucessfully updated $data!!!'),
            ),
          ],
        ),
      ),
    );
  }
}
