import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_driver_registry.dart';
import 'package:web3dart/web3dart.dart';

part 'admin.vm.freezed.dart';

@freezed
class AdminState with _$AdminState {
  const factory AdminState.init() = _AdminInit;
  const factory AdminState.loading() = _AdminLoading;
  const factory AdminState.error(String? message) = _AdminError;
  const factory AdminState.success(String? data) = _AdminSuccess;
}

class AdminVM extends StateNotifier<AdminState> {
  AdminVM(Reader read)
      : _rideDriverRegistryService = read(rideDriverRegistryProvider),
        super(const AdminState.init());

  final RideDriverRegistryService _rideDriverRegistryService;

  Future<void> approveApplicant(String applicantPubKey) async {
    try {
      state = const AdminState.loading();
      final applicantAddress = EthereumAddress.fromHex(applicantPubKey);
      final result = await _rideDriverRegistryService.approveApplicant(
          applicantAddress, 'testDocs');
      state = AdminState.success(result);
    } catch (ex) {
      state = AdminState.error(ex.toString());
    }
  }
}

final adminProvider =
    StateNotifierProvider.autoDispose<AdminVM, AdminState>((ref) {
  return AdminVM(ref.read);
});
