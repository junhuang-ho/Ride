import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ride/app/passenger/home/passenger.ride.vm.dart';
import 'package:ride/app/passenger/search/passenger.search.vm.dart';
import 'package:ride/app/passenger/widgets/prediction_tile.dart';
import 'package:ride/widgets/empty_content.dart';
import 'package:uuid/uuid.dart';

class PassengerSearchView extends HookConsumerWidget {
  const PassengerSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passengerSearch = ref.watch(passengerSearchProvider);

    final pickupController = useTextEditingController();
    final destController = useTextEditingController();
    final destFocusNode = useFocusNode();
    final _sessionToken = useState<String?>(null);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 1000,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, top: 48, right: 24, bottom: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 5),
                      Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          const Center(
                            child: Text(
                              'Set Destination',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Brand-Bold',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Consumer(
                        builder: (context, ref, _) {
                          final pickUpAddress = ref.watch(passengerRideProvider
                              .notifier
                              .select((passengerAddressVM) =>
                                  passengerAddressVM.pickUpAddress));
                          pickupController.text =
                              pickUpAddress?.placeName ?? '';

                          return SearchField(
                            imageName: 'images/pickicon.png',
                            hintText: 'Pickup Location',
                            textEditingController: pickupController,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      SearchField(
                        imageName: 'images/desticon.png',
                        hintText: 'Where to?',
                        textEditingController: destController,
                        focusNode: destFocusNode,
                        onChanged: (destination) async {
                          _sessionToken.value ??= const Uuid().v4();
                          await ref
                              .read(passengerSearchProvider.notifier)
                              .searchPlace(destination, _sessionToken.value!);
                        },
                      ),
                      const SizedBox(height: 20),
                      passengerSearch.when(
                        empty: () => const SizedBox(),
                        loading: () => const CircularProgressIndicator(),
                        error: (errorMsg) => EmptyContent(
                          title: 'Oops!',
                          message: errorMsg!,
                        ),
                        data: (predictions) => ListView.separated(
                          itemBuilder: (context, index) {
                            return PredictionTile(
                              prediction: predictions[index],
                              onSelect: () async {
                                await ref
                                    .read(passengerRideProvider.notifier)
                                    .updateDestinationAddress(
                                      predictions[index].placeId,
                                      _sessionToken.value!,
                                    );
                                _sessionToken.value = null;
                                context.pop();
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              color: Color(0xffe2e2e2),
                              thickness: 1),
                          itemCount: predictions.length,
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField(
      {Key? key,
      required this.imageName,
      required this.hintText,
      required this.textEditingController,
      this.focusNode,
      this.onChanged})
      : super(key: key);

  final String imageName;
  final String hintText;
  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image.asset(
          imageName,
          height: 16,
          width: 16,
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              focusNode: focusNode,
              onChanged: onChanged,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: hintText,
                fillColor: Colors.grey.shade800,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),
        )
      ],
    );
  }
}
