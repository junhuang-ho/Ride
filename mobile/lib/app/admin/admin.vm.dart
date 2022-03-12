import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_driver_registry.dart';
import 'package:ride/utils/fire_helper.dart';
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

  Future<List<Map<String, dynamic>>> loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await FirebaseStorage.instance.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "driver_id": fileMeta.customMetadata?['driver_id'] ?? 'Nobody',
      });
    });

    return files;
  }

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

final driverApplicantsProvider =
    StreamProvider.family<DatabaseEvent, String>((ref, status) {
  return FireHelper.getDriverApplicationsStream(status);
});
