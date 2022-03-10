import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

part 'apply.driver.vm.freezed.dart';

@freezed
class ApplyDriverState with _$ApplyDriverState {
  const factory ApplyDriverState.init() = _ApplyDriverInit;
  const factory ApplyDriverState.loading() = _ApplyDriverLoading;
  const factory ApplyDriverState.error(String? message) = _ApplyDriverError;
  const factory ApplyDriverState.applied() = _ApplyDriverApplied;
}

class ApplyDriverVM extends StateNotifier<ApplyDriverState> {
  ApplyDriverVM(Reader read) : super(const ApplyDriverState.init());

  Future<void> apply(Map<String, dynamic> formValue) async {
    state = const ApplyDriverState.loading();
    XFile? pickedImage;
    try {
      pickedImage = formValue['document'][0];

      File imageFile = File(pickedImage!.path);

      try {
        await FirebaseStorage.instance.ref(formValue['driverId']).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'driver_id': '${formValue['driverId']}',
            }));
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
}

final appplyDriverProvider =
    StateNotifierProvider<ApplyDriverVM, ApplyDriverState>((ref) {
  return ApplyDriverVM(ref.read);
});
