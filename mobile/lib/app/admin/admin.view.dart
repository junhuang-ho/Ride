import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/admin/admin.vm.dart';
import 'package:ride/app/admin/driver.application.vm.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/models/driver_application.dart';
import 'package:ride/services/ride/ride_driver_registry.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/empty_content.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/pending_transaction.dart';

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
                      return DriverApplicationCard(
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

class DriverApplicationCard extends HookConsumerWidget {
  const DriverApplicationCard({
    Key? key,
    required this.driverApplication,
  }) : super(key: key);

  final DriverApplication driverApplication;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverApplicationState =
        ref.watch(driverApplicationProvider(driverApplication));

    Future<void> _approveDriverApplication() async {
      await ref
          .read(driverApplicationProvider(driverApplication).notifier)
          .approve();
      ref
          .read(rideDriverRegistryProvider)
          .rideDriverRegistry
          .applicantApprovedEvents()
          .listen((event) {
        if (event.applicant.hexEip55 == driverApplication.driverId) {
          ref
              .read(driverApplicationProvider(driverApplication).notifier)
              .updateDriverApplication();
        }
      });
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: RideColors.cardColor,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: driverApplicationState.maybeWhen(
                    loading: () => const CircularProgressIndicator(),
                    orElse: () => Image.network(
                      ref
                          .read(driverApplicationProvider(driverApplication)
                              .notifier)
                          .fileUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                Flexible(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        driverApplication.firstName +
                            ' ' +
                            driverApplication.lastName,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(driverApplication.email),
                      const SizedBox(height: 10),
                      Text(driverApplication.phoneNumber),
                      Text(driverApplication.location),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(thickness: 2),
            driverApplicationState.maybeWhen(
              approving: () => const CircularProgressIndicator(),
              pendingBlockEnd: () => const PendingTransaction(),
              orElse: () => MaterialButton(
                height: 45,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text('Approve'),
                onPressed: () => _approveDriverApplication(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
