import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/admin/admin.vm.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class AdminView extends HookConsumerWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(adminProvider);
    final applicantAddrController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            OutlinedButton(
              child: const Text('Approve Driver'),
              onPressed: () async {
                await ref
                    .read(adminProvider.notifier)
                    .approveApplicant(applicantAddrController.text);
              },
            ),
          ],
          children: <Widget>[
            admin.when(
                init: () => PaperInput(
                      labelText: "Applicant's Wallet Address",
                      hintText: 'Please type in the public key',
                      maxLines: 3,
                      controller: applicantAddrController,
                    ),
                loading: () => const CircularProgressIndicator(),
                error: (message) => PaperValidationSummary([message!]),
                success: (data) => Text('Sucessfully registered $data!!!')),
          ],
        ),
      ),
    );
  }
}
