import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/driver/profile/update.driver.vm.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/paper_form.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class UpdateDriverView extends HookConsumerWidget {
  const UpdateDriverView({
    Key? key,
    required this.profileInfoType,
  }) : super(key: key);

  final ProfileInfoType profileInfoType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateDriver = ref.watch(updateDriverProvider);
    final updateDriverController = useTextEditingController();

    String getLabelText() {
      switch (profileInfoType) {
        case ProfileInfoType.email:
          return 'Email';
        case ProfileInfoType.phone:
          return 'Phone Number';
        case ProfileInfoType.maxTravelDistance:
          return 'Maximum Travel Distance';
      }
    }

    String getHintText() {
      switch (profileInfoType) {
        case ProfileInfoType.email:
          return 'your latest email address';
        case ProfileInfoType.phone:
          return 'your latest contact number';
        case ProfileInfoType.maxTravelDistance:
          return 'distance in metres';
      }
    }

    TextInputType getKeyboardType() {
      switch (profileInfoType) {
        case ProfileInfoType.email:
          return TextInputType.text;
        case ProfileInfoType.phone:
          return TextInputType.number;
        case ProfileInfoType.maxTravelDistance:
          return TextInputType.number;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Update ${getLabelText()}'),
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: updateDriver.maybeWhen(
                init: () => () async {
                  switch (profileInfoType) {
                    case ProfileInfoType.email:
                      await ref
                          .read(updateDriverProvider.notifier)
                          .updateDriverProfileEmail(
                              updateDriverController.text);
                      break;
                    case ProfileInfoType.phone:
                      await ref
                          .read(updateDriverProvider.notifier)
                          .updateDriverProfilePhoneNo(
                              updateDriverController.text);
                      break;
                    case ProfileInfoType.maxTravelDistance:
                      await ref
                          .read(updateDriverProvider.notifier)
                          .updateMaxMetresPerTrip(updateDriverController.text);
                      break;
                  }
                },
                orElse: () => null,
              )),
        ],
      ),
      body: Center(
        child: PaperForm(
          padding: 30,
          children: <Widget>[
            updateDriver.when(
              init: () => PaperInput(
                labelText: getLabelText(),
                hintText: 'Please type in ${getHintText()}',
                maxLines: 1,
                controller: updateDriverController,
                keyboardType: getKeyboardType(),
              ),
              loading: () => Column(
                children: const [
                  SpinKitSquareCircle(color: RideColors.primaryColor),
                  SizedBox(height: 15),
                  Text(
                    'Updating Driver Profile...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              error: (message) => PaperValidationSummary([message!]),
              success: (data) => Text('Sucessfully updated $data!!!'),
            ),
          ],
        ),
      ),
    );
  }
}
