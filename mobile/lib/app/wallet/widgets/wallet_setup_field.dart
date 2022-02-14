import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ride/app/wallet/setup.wallet.vm.dart';
import 'package:ride/widgets/paper_input.dart';
import 'package:ride/widgets/paper_validation_summary.dart';

class WalletSetupField extends ConsumerWidget {
  const WalletSetupField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final String label;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupWallet = ref.watch(setupWalletProvider);

    return Column(
      children: <Widget>[
        setupWallet.maybeWhen(
          error: (message) => PaperValidationSummary([message!]),
          orElse: () => const SizedBox(),
        ),
        PaperInput(
          labelText: label,
          hintText: hintText,
          maxLines: 3,
          controller: controller,
        ),
      ],
    );
  }
}
