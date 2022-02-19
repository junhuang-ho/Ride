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
            title: const Text('URI'),
            trailing: Text('$uri'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Max Metres Per Trip'),
            trailing: Text('$maxMetresPerTrip'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Metres Travelled'),
            trailing: Text('$metresTravelled'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Count Start'),
            trailing: Text('$countStart'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Count End'),
            trailing: Text('$countEnd'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Total Rating'),
            trailing: Text('$totalRating'),
          ),
          ListTile(
            leading: const Icon(Icons.perm_identity),
            title: const Text('Count Rating'),
            trailing: Text('$countRating'),
          ),
        ],
      ),
    );
  }
}
