import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/driver_reputation.dart';
import 'package:ride/services/crypto.dart';
import 'package:ride/services/repository.dart';
import 'package:ride/services/ride/ride_badge.dart';

part 'driver.vm.freezed.dart';

@freezed
class DriverState with _$DriverState {
  const factory DriverState.loading() = _DriverLoading;
  const factory DriverState.error(String? message) = _DriverError;
  const factory DriverState.data(DriverReputation driverReputation) =
      _DriverData;
}

class DriverVM extends StateNotifier<DriverState> {
  DriverVM(Reader read)
      : _crypto = read(cryptoProvider),
        _repository = read(repositoryProvider),
        _rideBadgeService = read(rideBadgeProvider),
        super(const DriverState.loading()) {
    getDriverReputation();
  }

  final Crypto _crypto;
  final Repository _repository;
  final RideBadgeService _rideBadgeService;

  Future<void> getDriverReputation() async {
    try {
      state = const DriverState.loading();
      final credentials = _repository.getPrivateKey();
      final driverAddress = await _crypto.getPublicAddress(credentials!);
      final driverReputation =
          await _rideBadgeService.getDriverReputation(driverAddress);
      state = DriverState.data(driverReputation);
    } catch (ex) {
      state = DriverState.error(ex.toString());
    }
  }
}

final driverProvider =
    StateNotifierProvider.autoDispose<DriverVM, DriverState>((ref) {
  return DriverVM(ref.read);
});
