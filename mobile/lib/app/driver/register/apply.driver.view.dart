import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/driver/register/apply.driver.vm.dart';
import 'package:ride/app/driver/widgets/taxi_button.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/empty_content.dart';
import 'package:ride/widgets/ride_text_field.dart';

class ApplyDriverView extends HookConsumerWidget {
  ApplyDriverView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final applyDriver = ref.watch(appplyDriverProvider);

    return Scaffold(
      body: Center(
        child: applyDriver.when(
          loading: () => const CircularProgressIndicator(),
          error: (errorMsg) =>
              EmptyContent(title: 'Something goes wrong', message: errorMsg!),
          applied: () => const EmptyContent(
            title: 'We Have Received Your Application!',
            message: 'Pending Admin Approval...',
          ),
          init: () => FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RideTextField(
                  name: 'driverId',
                  readOnly: true,
                  label: 'Your Driver ID',
                  initialValue: auth.maybeWhen(
                    authenticated: (accountData) => accountData.publicKey,
                    orElse: () => '',
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 48.0),
                  child: FormBuilderImagePicker(
                    name: 'document',
                    decoration: const InputDecoration(
                      labelText: 'Upload Document',
                      border: InputBorder.none,
                    ),
                    maxImages: 1,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 55.0),
                  child: TaxiButton(
                    title: 'Submit',
                    color: RideColors.colorGreen,
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() == true) {
                        await ref
                            .read(appplyDriverProvider.notifier)
                            .apply(_formKey.currentState!.value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
