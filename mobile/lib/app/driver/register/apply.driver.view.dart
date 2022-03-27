import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/driver/register/apply.driver.vm.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/ride_text_field.dart';

class ApplyDriverView extends HookConsumerWidget {
  ApplyDriverView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applyDriver = ref.watch(applyDriverProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Driver Application'),
      ),
      floatingActionButton: applyDriver.whenOrNull(
        init: () => FloatingActionButton.extended(
            label: const Text('Apply Now'),
            icon: const Icon(Icons.app_registration_rounded),
            onPressed: () async {
              if (_formKey.currentState!.saveAndValidate()) {
                await ref
                    .read(applyDriverProvider.notifier)
                    .apply(_formKey.currentState!.value);
              }
            }),
        approved: () => FloatingActionButton.extended(
          label: const Text('Register now'),
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => context.go('/register_driver'),
        ),
      ),
      body: applyDriver.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (errorMsg) => ApplicationStatusContent(
            title: 'Something goes wrong', message: errorMsg!),
        applied: () => const ApplicationStatusContent(
          title: 'We Have Received Your Application!',
          message: 'It\'s Pending Admin Approval...',
          secondMessage: 'Thank You For Your Patience...',
        ),
        approved: () => const ApplicationStatusContent(
          title: 'Your Application has been approved!',
          message: 'Please proceed with registration...',
        ),
        init: () => ApplyDriverForm(formKey: _formKey),
      ),
    );
  }
}

class ApplyDriverForm extends HookConsumerWidget {
  const ApplyDriverForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
              child: Row(
                children: const [
                  Text(
                    'Sign up to drive',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            RideTextField(
              name: 'driverId',
              readOnly: true,
              focusNode:
                  formKey.currentState?.fields['driverId']!.effectiveFocusNode,
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
            Row(
              children: [
                Expanded(
                  child: RideTextField(
                    name: 'firstName',
                    label: 'First name',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                ),
                Expanded(
                  child: RideTextField(
                    name: 'lastName',
                    label: 'Last name',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                ),
              ],
            ),
            RideTextField(
              name: 'email',
              label: 'Email',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.email(context),
              ]),
            ),
            RideTextField(
              name: 'phoneNumber',
              label: 'Phone number',
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
                FormBuilderValidators.numeric(context),
              ]),
            ),
            RideTextField(
              name: 'location',
              label: 'Your location',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Flexible(flex: 1, child: SizedBox()),
                Flexible(
                  flex: 1,
                  child: FormBuilderImagePicker(
                    name: 'document',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Upload Document',
                      border: InputBorder.none,
                      errorMaxLines: 2,
                    ),
                    maxImages: 1,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                ),
                const Flexible(flex: 1, child: SizedBox()),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ApplicationStatusContent extends StatelessWidget {
  const ApplicationStatusContent({
    Key? key,
    required this.title,
    required this.message,
    this.secondMessage,
  }) : super(key: key);

  final String title;
  final String message;
  final String? secondMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: RideColors.primaryColor,
                fontSize: 32.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 15),
            if (secondMessage != null)
              Text(
                secondMessage!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
