import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_driver_registry.dart';

part 'update.driver.vm.freezed.dart';

@freezed
class UpdateDriverState with _$UpdateDriverState {
  const factory UpdateDriverState.init() = _UpdateDriverInit;
  const factory UpdateDriverState.loading() = _UpdateDriverLoading;
  const factory UpdateDriverState.error(String? message) = _UpdateDriverError;
  const factory UpdateDriverState.success(String? data) = _UpdateDriverSuccess;
}

class UpdateDriverVM extends StateNotifier<UpdateDriverState> {
  UpdateDriverVM(Reader read)
      : _rideDriverRegistryService = read(rideDriverRegistryProvider),
        super(const UpdateDriverState.init());

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
}

final updateDriverProvider =
    StateNotifierProvider.autoDispose<UpdateDriverVM, UpdateDriverState>((ref) {
  return UpdateDriverVM(ref.read);
});
