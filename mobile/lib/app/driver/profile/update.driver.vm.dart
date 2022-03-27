import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/services/ride/ride_driver_registry.dart';
import 'package:ride/utils/fire_helper.dart';

part 'update.driver.vm.freezed.dart';

enum ProfileInfoType { email, phone, maxTravelDistance }

@freezed
class UpdateDriverState with _$UpdateDriverState {
  const factory UpdateDriverState.init() = _UpdateDriverInit;
  const factory UpdateDriverState.loading() = _UpdateDriverLoading;
  const factory UpdateDriverState.error(String? message) = _UpdateDriverError;
  const factory UpdateDriverState.success(String? data) = _UpdateDriverSuccess;
}

class UpdateDriverVM extends StateNotifier<UpdateDriverState> {
  UpdateDriverVM(Reader read)
      : _authVM = read(authProvider.notifier),
        _rideDriverRegistryService = read(rideDriverRegistryProvider),
        super(const UpdateDriverState.init());

  final AuthVM _authVM;
  final RideDriverRegistryService _rideDriverRegistryService;

  Future<void> updateMaxMetresPerTrip(String maxMetresPerTrip) async {
    try {
      state = const UpdateDriverState.loading();
      final parsedMaxMetresPerTrip = BigInt.parse(maxMetresPerTrip);
      final result = await _rideDriverRegistryService
          .updateMaxMetresPerTrip(parsedMaxMetresPerTrip);
      state = UpdateDriverState.success(result);
    } catch (ex) {
      state = UpdateDriverState.error(ex.toString());
    }
  }

  Future<void> updateDriverProfileEmail(String email) async {
    try {
      state = const UpdateDriverState.loading();
      final driverId = await _authVM.getPublicKey();
      await FireHelper.updateDriverApplication(driverId!, {"email": email});
      state = UpdateDriverState.success(email);
    } catch (ex) {
      state = UpdateDriverState.error(ex.toString());
    }
  }

  Future<void> updateDriverProfilePhoneNo(String phoneNumber) async {
    try {
      state = const UpdateDriverState.loading();
      final driverId = await _authVM.getPublicKey();
      await FireHelper.updateDriverApplication(
          driverId!, {"phone_number": phoneNumber});
      state = UpdateDriverState.success(phoneNumber);
    } catch (ex) {
      state = UpdateDriverState.error(ex.toString());
    }
  }
}

final updateDriverProvider =
    StateNotifierProvider.autoDispose<UpdateDriverVM, UpdateDriverState>((ref) {
  return UpdateDriverVM(ref.read);
});
