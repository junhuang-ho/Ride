import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/auth/auth.vm.dart';
import 'package:ride/app/driver/profile/driver.profile.vm.dart';
import 'package:ride/app/driver/profile/update.driver.vm.dart';
import 'package:ride/app/passenger/widgets/alert.dart';
import 'package:ride/app/passenger/widgets/reputation_details.dart';
import 'package:ride/utils/ride_colors.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class DriverProfileView extends HookConsumerWidget {
  const DriverProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverProfile = ref.watch(driverProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: driverProfile.maybeWhen(
              loading: () => null,
              orElse: () => () async {
                await ref
                    .read(driverProfileProvider.notifier)
                    .getDriverReputation();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Driver Reputation updated'),
                  duration: Duration(milliseconds: 800),
                ));
              },
            ),
          ),
        ],
      ),
      body: driverProfile.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (message) => PaperValidationSummary([message!]),
        data: (driverReputation, driverProfile) => SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                name: driverProfile.firstName + ' ' + driverProfile.lastName,
                metresTravelled: driverReputation.metresTravelled,
                tripCompleted: driverReputation.countEnd,
                rating:
                    driverReputation.totalRating / driverReputation.countRating,
              ),
              const Divider(thickness: 8, color: RideColors.grey),
              AccountSettings(
                email: driverProfile.email,
                phone: driverProfile.phoneNumber,
                maxTravelDistance: driverReputation.maxMetresPerTrip,
              ),
              const Divider(thickness: 8, color: RideColors.grey),
              AccountUtilities(
                onReset: () => Alert(
                    title: 'Warning',
                    text:
                        'Without your seed phrase or private key you cannot restore your wallet balance',
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Confirm Log out'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await ref.read(authProvider.notifier).deleteAccount();
                          context.go('/');
                        },
                      ),
                    ]).show(context),
                onRevealMnemonic: () => Alert(
                  title: 'Seed Phrase',
                  text:
                      'WARNING, In production environment, the seed phrase should be protected with password.\r\n\r\n'
                      '${ref.read(authProvider.notifier).getMnemonic() ?? "-"}',
                  actions: [
                    TextButton(
                      child: const Text('close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('copy and close'),
                      onPressed: () {
                        final mnemonic =
                            ref.read(authProvider.notifier).getMnemonic();
                        Clipboard.setData(ClipboardData(text: mnemonic));
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ).show(context),
                onRevealKey: () => Alert(
                  title: 'Private key',
                  text:
                      'WARNING, In production environment, the private key should be protected with password.\r\n\r\n'
                      '${ref.read(authProvider.notifier).getPrivateKey() ?? "-"}',
                  actions: [
                    TextButton(
                      child: const Text('close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('copy and close'),
                      onPressed: () {
                        final privateKey =
                            ref.read(authProvider.notifier).getPrivateKey();
                        Clipboard.setData(ClipboardData(text: privateKey));
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ).show(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.name,
    required this.metresTravelled,
    required this.tripCompleted,
    required this.rating,
  }) : super(key: key);

  final String name;
  final BigInt metresTravelled;
  final BigInt tripCompleted;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 15),
            const Icon(
              Icons.account_circle_rounded,
              size: 100,
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 15),
            ReputationDetails(
              metresTravelled: metresTravelled,
              tripCompleted: tripCompleted,
              rating: rating,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ],
    );
  }
}

class AccountSettings extends HookConsumerWidget {
  const AccountSettings({
    Key? key,
    required this.email,
    required this.phone,
    required this.maxTravelDistance,
  }) : super(key: key);

  final String email;
  final String phone;
  final BigInt maxTravelDistance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: const Text('Email'),
          subtitle: Text(email),
          onTap: () =>
              context.go('/driver/update', extra: ProfileInfoType.email),
        ),
        const Divider(indent: 15, endIndent: 15, color: RideColors.grey),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('Phone'),
          subtitle: Text(phone),
          onTap: () =>
              context.go('/driver/update', extra: ProfileInfoType.phone),
        ),
        const Divider(indent: 15, endIndent: 15, color: RideColors.grey),
        ListTile(
          leading: const Icon(Icons.edit_road),
          title: const Text('Maximum Travel Distance'),
          subtitle: Text(
            '${(maxTravelDistance / BigInt.from(1000)).toStringAsFixed(2)} KM',
          ),
          onTap: () => context.go('/driver/update',
              extra: ProfileInfoType.maxTravelDistance),
        ),
      ],
    );
  }
}

class AccountUtilities extends HookConsumerWidget {
  const AccountUtilities({
    Key? key,
    required this.onReset,
    required this.onRevealMnemonic,
    required this.onRevealKey,
  }) : super(key: key);

  final GestureTapCallback? onReset;
  final GestureTapCallback? onRevealMnemonic;
  final GestureTapCallback? onRevealKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Consumer(
          builder: (context, ref, _) {
            final isMnemonicExist = ref.watch(authProvider.notifier
                .select((authVM) => authVM.isMnemonicExist));
            if (isMnemonicExist) {
              return ListTile(
                title: const Text('Reveal Seed Phrase',
                    style: TextStyle(fontSize: 16)),
                leading: const Icon(Icons.security),
                onTap: onRevealMnemonic,
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        ListTile(
          title:
              const Text('Reveal private key', style: TextStyle(fontSize: 16)),
          leading: const Icon(Icons.vpn_key),
          onTap: onRevealKey,
        ),
        const Divider(indent: 15, endIndent: 15, color: RideColors.grey),
        ListTile(
          title: const Text('Log out', style: TextStyle(fontSize: 16)),
          leading: const Icon(Icons.logout),
          onTap: onReset,
        ),
      ],
    );
  }
}
