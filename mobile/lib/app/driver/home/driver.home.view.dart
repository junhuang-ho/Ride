import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/home/driver.home.vm.dart';
import 'package:ride/app/driver/widgets/availability_button.dart';
import 'package:ride/app/driver/widgets/confirm_sheet.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/widgets/empty_content.dart';

class DriverHomeView extends HookConsumerWidget {
  const DriverHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverHomeVM = ref.read(driverHomeProvider.notifier);

    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: const EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: kGooglePlex,
          onMapCreated: (GoogleMapController controller) async {
            await driverHomeVM.getCurrentPosition(controller);
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: Theme.of(context).backgroundColor,
        ),
        const DriverAvailability(),
      ],
    );
  }
}

class DriverAvailability extends HookConsumerWidget {
  const DriverAvailability({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverHome = ref.watch(driverHomeProvider);
    final driverHomeVM = ref.read(driverHomeProvider.notifier);

    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AvailabilityButton(
            title: driverHome.maybeWhen(
              offline: () => 'GO ONLINE',
              online: () => 'GO OFFLINE',
              orElse: () => '',
            ),
            color: driverHome.maybeWhen(
              offline: () => Colors.orange,
              online: () => Colors.green,
              orElse: () => Colors.transparent,
            ),
            onPressed: () {
              showModalBottomSheet(
                isDismissible: false,
                context: context,
                builder: (context) => driverHome.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (errorMsg) => EmptyContent(
                    title: 'Something goes wrong',
                    message: errorMsg!,
                  ),
                  offline: () => ConfirmSheet(
                    title: 'GO ONLINE',
                    subtitle:
                        'You are about to become available to receive trip requests',
                    onPressed: () {
                      driverHomeVM.goOnline();
                      Navigator.pop(context);
                    },
                  ),
                  online: () => ConfirmSheet(
                    title: 'GO OFFLINE',
                    subtitle: 'You will stop receiving new trip requests',
                    onPressed: () {
                      driverHomeVM.goOffline();
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
