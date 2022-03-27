import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/models/driver_application.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/fire_helper.dart';

part 'apply.driver.vm.freezed.dart';

@freezed
class ApplyDriverState with _$ApplyDriverState {
  const factory ApplyDriverState.init() = _ApplyDriverInit;
  const factory ApplyDriverState.loading() = _ApplyDriverLoading;
  const factory ApplyDriverState.error(String? message) = _ApplyDriverError;
  const factory ApplyDriverState.applied() = _ApplyDriverApplied;
  const factory ApplyDriverState.approved() = _ApplyDriverApproved;
}

class ApplyDriverVM extends StateNotifier<ApplyDriverState> {
  ApplyDriverVM(Reader read)
      : _authVM = read(authProvider.notifier),
        super(const ApplyDriverState.init()) {
    checkRegistrationStatus();
  }

  final AuthVM _authVM;

  Future<void> checkRegistrationStatus() async {
    try {
      state = const ApplyDriverState.loading();
      final publicKey = await _authVM.getPublicKey();
      final driverApplication =
          await FireHelper.getDriverApplication(publicKey ?? '');
      state = _getDriverApplicationStatus(driverApplication);
    } on FirebaseException catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
      state = const ApplyDriverState.init();
    }
  }

  Future<void> apply(Map<String, dynamic> formValue) async {
    state = const ApplyDriverState.loading();
    XFile? pickedDoc;
    try {
      pickedDoc = formValue['document'][0];

      final String fileName = path.basename(pickedDoc!.path);
      File imageFile = File(pickedDoc.path);

      try {
        final driverId = formValue['driverId'];
        final firstName = formValue['firstName'];
        final lastName = formValue['lastName'];
        final email = formValue['email'];
        final phoneNumber = formValue['phoneNumber'];
        final location = formValue['location'];

        Map<String, Object> applicantMap = {
          'driver_id': driverId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_number': phoneNumber,
          'location': location,
          'created_at': DateTime.now().toString(),
          'file_name': fileName,
          'status': Strings.pendingApproval,
        };

        await FirebaseStorage.instance.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'driver_id': '$driverId',
            }));
        await FireHelper.addDriverApplication(driverId, applicantMap);
        state = const ApplyDriverState.applied();
      } on FirebaseException catch (error) {
        state = ApplyDriverState.error(error.toString());
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      state = ApplyDriverState.error(err.toString());
      if (kDebugMode) {
        print(err);
      }
    }
  }

  ApplyDriverState _getDriverApplicationStatus(
      DriverApplication? driverApplication) {
    if (driverApplication == null) {
      return const ApplyDriverState.init();
    }
    if (driverApplication.status == Strings.approved) {
      return const ApplyDriverState.approved();
    } else {
      return const ApplyDriverState.applied();
    }
  }
}

final applyDriverProvider =
    StateNotifierProvider.autoDispose<ApplyDriverVM, ApplyDriverState>((ref) {
  return ApplyDriverVM(ref.read);
});
