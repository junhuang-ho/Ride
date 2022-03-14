import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_driver_registry.dart';

part 'register.driver.vm.freezed.dart';

@freezed
class RegisterDriverState with _$RegisterDriverState {
  const factory RegisterDriverState.init() = _RegisterDriverInit;
  const factory RegisterDriverState.loading() = _RegisterDriverLoading;
  const factory RegisterDriverState.error(String? message) =
      _RegisterDriverError;
  const factory RegisterDriverState.success(String? data) =
      _RegisterDriverSuccess;
}

class RegisterDriverVM extends StateNotifier<RegisterDriverState> {
  RegisterDriverVM(Reader read)
      : _rideDriverRegistryService = read(rideDriverRegistryProvider),
        super(const RegisterDriverState.init());

  final RideDriverRegistryService _rideDriverRegistryService;

  Future<void> registerAsDriver(String maxMetresPerTrip) async {
    try {
      state = const RegisterDriverState.loading();
      final parsedMaxMetresPerTrip = BigInt.parse(maxMetresPerTrip);
      final result = await _rideDriverRegistryService
          .registerAsDriver(parsedMaxMetresPerTrip);
      state = RegisterDriverState.success(result);
    } catch (ex) {
      state = RegisterDriverState.error(ex.toString());
    }
  }
}

final registerDriverProvider =
    StateNotifierProvider.autoDispose<RegisterDriverVM, RegisterDriverState>(
        (ref) {
  return RegisterDriverVM(ref.read);
});
