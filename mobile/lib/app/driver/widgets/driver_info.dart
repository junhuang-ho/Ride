import 'package:flutter/material.dart';

class DriverInfo extends StatelessWidget {
  final BigInt id;
  final String? uri;
  final BigInt maxMetresPerTrip;
  final BigInt metresTravelled;
  final BigInt countStart;
  final BigInt countEnd;
  final BigInt totalRating;
  final BigInt countRating;

  const DriverInfo({
    Key? key,
    required this.id,
    required this.uri,
    required this.maxMetresPerTrip,
    required this.metresTravelled,
    required this.countStart,
    required this.countEnd,
    required this.totalRating,
    required this.countRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('ID'),
            trailing: Text('$id'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Documents'),
            trailing: Text('$uri'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Maximum Travel Distance'),
            trailing: Text('$maxMetresPerTrip'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Distance Travelled'),
            trailing: Text('$metresTravelled'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Number of Trips Began'),
            trailing: Text('$countStart'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Number of Trips Completed'),
            trailing: Text('$countEnd'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Total Rating'),
            trailing: Text('$totalRating'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('No. of Rating'),
            trailing: Text('$countRating'),
          ),
        ],
      ),
    );
  }
}
