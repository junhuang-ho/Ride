import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/account.dart';

part 'passenger.home.vm.freezed.dart';

@freezed
class PassengerHomeState with _$PassengerHomeState {
  const factory PassengerHomeState.loading() = _PassengerHomeLoading;
  const factory PassengerHomeState.error(String? message) = _PassengerHomeError;
  const factory PassengerHomeState.data(Account account) = _PassengerHomeData;
}

class PassengerHomeVM extends StateNotifier<PassengerHomeState> {
  PassengerHomeVM(Reader read) : super(const PassengerHomeState.loading());
}

final passengerHomeProvider =
    StateNotifierProvider<PassengerHomeVM, PassengerHomeState>((ref) {
  return PassengerHomeVM(ref.read);
});
