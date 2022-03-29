import 'package:flutter/material.dart';

class PaperForm extends StatelessWidget {
  const PaperForm({
    Key? key,
    this.formKey,
    required this.children,
    this.padding = 8,
    this.actionButtons,
    this.crossAxisAlignment,
  }) : super(key: key);

  final Key? formKey;
  final List<Widget> children;
  final List<Widget>? actionButtons;
  final double padding;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
            children: [
              ...children,
              ..._buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    if (actionButtons == null) {
      return List.empty();
    }

    return [
      const SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actionButtons!,
      )
    ];
  }
}
