import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/admin/admin.vm.dart';
import 'package:ride/app/admin/driver.application.vm.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/models/driver_application.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/widgets/empty_content.dart';
import 'package:ride/widgets/paper_form.dart';

class AdminView extends HookConsumerWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<DatabaseEvent> pendingDriverApplicants =
        ref.watch(driverApplicantsProvider(Strings.pendingApproval));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            TextButton(
              child: const Text('Log out'),
              onPressed: () async {
                await ref.read(authProvider.notifier).deleteAccount();
                context.go('/');
              },
            ),
          ],
          children: <Widget>[
            pendingDriverApplicants.when(
              data: (dbEvent) {
                final driverApplications = dbEvent.snapshot.children;
                return Expanded(
                  child: ListView.builder(
                    itemCount: driverApplications.length,
                    itemBuilder: (context, index) {
                      final driverApplication = DriverApplication.parseRaw(
                        driverApplications.elementAt(index).value!,
                      );
                      return DriverApplicationListTile(
                          driverApplication: driverApplication);
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => EmptyContent(
                title: 'Something Goes Wrong',
                message: err.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverApplicationListTile extends HookConsumerWidget {
  const DriverApplicationListTile({
    Key? key,
    required this.driverApplication,
  }) : super(key: key);

  final DriverApplication driverApplication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverApplicationState =
        ref.watch(driverApplicationProvider(driverApplication));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        dense: false,
        leading: driverApplicationState.maybeWhen(
          loading: () => const CircularProgressIndicator(),
          orElse: () => Image.network(ref
              .read(driverApplicationProvider(driverApplication).notifier)
              .fileUrl),
        ),
        title: Text(driverApplication.driverId),
        trailing: driverApplicationState.maybeWhen(
          approving: () => const CircularProgressIndicator(),
          orElse: () => TextButton(
            child: const Text('Approve'),
            onPressed: () async {
              await ref
                  .read(driverApplicationProvider(driverApplication).notifier)
                  .approve();
            },
          ),
        ),
      ),
    );
  }
}
