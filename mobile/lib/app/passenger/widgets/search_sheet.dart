import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchSheet extends HookConsumerWidget {
  const SearchSheet({
    Key? key,
    required this.searchSheetHeight,
    this.onSearchBarTap,
  }) : super(key: key);

  final double searchSheetHeight;
  final Function()? onSearchBarTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: searchSheetHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: onSearchBarTap,
                  child: const SearchBar(),
                ),
                const SizedBox(height: 22),
                const AddFavouriteLocation(
                  iconData: Icons.home,
                  location: 'Home',
                  locationDesc: 'Your residential address',
                ),
                const SizedBox(height: 16),
                const AddFavouriteLocation(
                  iconData: Icons.work,
                  location: 'Work',
                  locationDesc: 'Your office address',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 0.5,
            offset: Offset(
              0.7,
              0.7,
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 10),
            const Text('Search Destination'),
          ],
        ),
      ),
    );
  }
}

class AddFavouriteLocation extends StatelessWidget {
  const AddFavouriteLocation(
      {Key? key,
      required this.iconData,
      required this.location,
      required this.locationDesc})
      : super(key: key);

  final IconData iconData;
  final String location;
  final String locationDesc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          iconData,
          color: const Color(0xFFadadad),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Add $location'),
            const SizedBox(height: 3),
            Text(
              locationDesc,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFadadad),
              ),
            ),
          ],
        )
      ],
    );
  }
}
