import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/models/prediction.dart';
import 'package:ride/services/maps_api.dart';

part 'passenger.search.vm.freezed.dart';

@freezed
class PassengerSearchState with _$PassengerSearchState {
  const factory PassengerSearchState.loading() = _PassengerSearchLoading;
  const factory PassengerSearchState.error(String? message) =
      _PassengerSearchError;
  const factory PassengerSearchState.data(List<Prediction> destPredictionList) =
      _PassengerSearchData;
  const factory PassengerSearchState.empty() = _PassengerSearchEmpty;
}

class PassengerSearchVM extends StateNotifier<PassengerSearchState> {
  PassengerSearchVM() : super(const PassengerSearchState.empty());

  Future<void> searchPlace(String placeName, String sessionToken) async {
    try {
      state = const PassengerSearchState.loading();
      final searchResult =
          await MapsAPI.placeAutoComplete(placeName, sessionToken);
      if (searchResult == 'failed') {
        state = const PassengerSearchState.error('RESPONSE FAILED ON SEARCH');
        return;
      }
      if (searchResult['status'] == 'OK') {
        var predictionsJson = searchResult['predictions'];
        var predictions = (predictionsJson as List)
            .map((predictionJson) => Prediction.fromJson(predictionJson))
            .toList();
        state = predictions.isNotEmpty
            ? PassengerSearchState.data(predictions)
            : const PassengerSearchState.empty();
        return;
      }
      state = const PassengerSearchState.empty();
    } catch (ex) {
      state = PassengerSearchState.error(ex.toString());
    }
  }
}

final passengerSearchProvider =
    StateNotifierProvider.autoDispose<PassengerSearchVM, PassengerSearchState>(
        (ref) {
  return PassengerSearchVM();
});
