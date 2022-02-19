import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/driver.vm.dart';
import 'package:ride/app/driver/widgets/driver_info.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class DriverView extends HookConsumerWidget {
  const DriverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(driverProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: driver.maybeWhen(
              loading: () => null,
              orElse: () => () async {
                await ref.read(driverProvider.notifier).getDriverReputation();
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
              child: const Text('Register as Driver'),
              onPressed: () => context.go('/home/driver/register'),
            ),
          ],
          children: <Widget>[
            driver.when(
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
