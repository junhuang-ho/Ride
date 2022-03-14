import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/driver/profile/driver.profile.vm.dart';
import 'package:ride/app/driver/widgets/driver_info.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class DriverProfileView extends HookConsumerWidget {
  const DriverProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverProfile = ref.watch(driverProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: driverProfile.maybeWhen(
              loading: () => null,
              orElse: () => () async {
                await ref
                    .read(driverProfileProvider.notifier)
                    .getDriverReputation();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Driver Reputation updated'),
                  duration: Duration(milliseconds: 800),
                ));
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          actionButtons: <Widget>[
            OutlinedButton(
              child: const Text('Update'),
              onPressed: () => context.go('/driver/update'),
            ),
            TextButton(
              child: const Text('reset'),
              onPressed: () async {
                await ref.read(authProvider.notifier).deleteAccount();
                context.go('/');
              },
            ),
          ],
          children: <Widget>[
            driverProfile.when(
              loading: () => const CircularProgressIndicator(),
              error: (message) => PaperValidationSummary([message!]),
              data: (driverData) => DriverInfo(
                id: driverData.id,
                uri: driverData.uri,
                maxMetresPerTrip: driverData.maxMetresPerTrip,
                metresTravelled: driverData.metresTravelled,
                countStart: driverData.countStart,
                countEnd: driverData.countEnd,
                totalRating: driverData.totalRating,
                countRating: driverData.countRating,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
