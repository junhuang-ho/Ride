import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/driver_application.dart';
import 'package:ride/services/ride/ride_driver_registry.dart';
import 'package:ride/utils/constants.dart';
import 'package:ride/utils/fire_helper.dart';
import 'package:web3dart/web3dart.dart';

part 'driver.application.vm.freezed.dart';

@freezed
class DriverApplicationState with _$DriverApplicationState {
  const factory DriverApplicationState.loading() = _DriverApplicationLoading;
  const factory DriverApplicationState.error(String? message) =
      _DriverApplicationError;
  const factory DriverApplicationState.loaded() = _DriverApplicationLoaded;
  const factory DriverApplicationState.approving() =
      _DriverApplicationApproving;
  const factory DriverApplicationState.pendingBlockEnd() =
      _DriverApplicationPendingBlockEnd;
  const factory DriverApplicationState.approved() = _DriverApplicationApproved;
}

class DriverApplicationVM extends StateNotifier<DriverApplicationState> {
  DriverApplicationVM(Reader read, this.driverApplication)
      : _rideDriverRegistryService = read(rideDriverRegistryProvider),
        super(const DriverApplicationState.loading()) {
    loadImages();
  }

  final RideDriverRegistryService _rideDriverRegistryService;
  final DriverApplication driverApplication;
  late String fileUrl;

  Future<void> loadImages() async {
    state = const DriverApplicationState.loading();
    final file = FirebaseStorage.instance.ref(driverApplication.fileName);
    fileUrl = await file.getDownloadURL();
    state = const DriverApplicationState.loaded();
  }

  Future<void> approve() async {
    try {
      state = const DriverApplicationState.approving();
      final applicantAddress =
          EthereumAddress.fromHex(driverApplication.driverId);
      await _rideDriverRegistryService.approveApplicant(
          applicantAddress, 'testDocs');
      state = const DriverApplicationState.pendingBlockEnd();
    } catch (ex) {
      state = DriverApplicationState.error(ex.toString());
    }
  }

  Future<void> updateDriverApplication() async {
    try {
      await FireHelper.updateDriverApplication(
          driverApplication.driverId, {"status": Strings.approved});
      state = const DriverApplicationState.approved();
    } catch (ex) {
      state = DriverApplicationState.error(ex.toString());
    }
  }
}

final driverApplicationProvider = StateNotifierProvider.family<
    DriverApplicationVM,
    DriverApplicationState,
    DriverApplication>((ref, driverApplication) {
  return DriverApplicationVM(ref.read, driverApplication);
});
