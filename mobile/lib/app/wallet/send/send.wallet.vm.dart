import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/services/ride/ride_hub.dart';
import 'package:web3dart/web3dart.dart';

part 'send.wallet.vm.freezed.dart';

enum TokenType { matic, weth }

@freezed
class SendWalletState with _$SendWalletState {
  const factory SendWalletState.init() = _SendWalletInit;
  const factory SendWalletState.loading() = _SendWalletLoading;
  const factory SendWalletState.error(String? message) = _SendWalletError;
  const factory SendWalletState.success(String? data) = _SendWalletSuccess;
}

class SendWalletVM extends StateNotifier<SendWalletState> {
  SendWalletVM(Reader read)
      : _rideHub = read(rideHubProvider),
        super(const SendWalletState.init());

  final RideHubService _rideHub;

  Future<void> sendMaticTo(String receiverAddress, String sendAmount) async {
    try {
      state = const SendWalletState.loading();
      final sendAmountInWei =
          BigInt.from(double.parse(sendAmount) * pow(10, 18));
      final result = await _rideHub.sendEth(
        EthereumAddress.fromHex(receiverAddress),
        EtherAmount.fromUnitAndValue(EtherUnit.wei, sendAmountInWei),
      );
      state = SendWalletState.success(result);
    } catch (ex) {
      state = SendWalletState.error(ex.toString());
    }
  }

  Future<void> sendWETHTo(String receiverAddress, String sendAmount) async {
    try {
      state = const SendWalletState.loading();
      final sendAmountInWei =
          BigInt.from(double.parse(sendAmount) * pow(10, 18));
      final result = await _rideHub.sendWETH(
        EthereumAddress.fromHex(receiverAddress),
        EtherAmount.fromUnitAndValue(EtherUnit.wei, sendAmountInWei),
      );
      state = SendWalletState.success(result);
    } catch (ex) {
      state = SendWalletState.error(ex.toString());
    }
  }
}

final sendWalletProvider =
    StateNotifierProvider.autoDispose<SendWalletVM, SendWalletState>((ref) {
  return SendWalletVM(ref.read);
});
