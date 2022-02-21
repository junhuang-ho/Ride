import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

part 'send.account.vm.freezed.dart';

@freezed
class SendAccountState with _$SendAccountState {
  const factory SendAccountState.init() = _SendAccountInit;
  const factory SendAccountState.loading() = _SendAccountLoading;
  const factory SendAccountState.error(String? message) = _SendAccountError;
  const factory SendAccountState.success(String? data) = _SendAccountSuccess;
}

class SendAccountVM extends StateNotifier<SendAccountState> {
  SendAccountVM(Reader read)
      : _rideHub = read(rideHubProvider),
        super(const SendAccountState.init());

  final RideHubService _rideHub;

  Future<void> sendWETHTo(String receiverAddress, String amount) async {
    try {
      state = const SendAccountState.loading();
      final result = await _rideHub.sendWETH(
        EthereumAddress.fromHex(receiverAddress),
        EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
      );
      state = SendAccountState.success(result);
    } catch (ex) {
      state = SendAccountState.error(ex.toString());
    }
  }
}

final sendAccountProvider =
    StateNotifierProvider.autoDispose<SendAccountVM, SendAccountState>((ref) {
  return SendAccountVM(ref.read);
});
