import 'package:flutter/material.dart';

class CommonSheet extends StatelessWidget {
  const CommonSheet({
    Key? key,
    required this.sheetHeight,
    required this.child,
  }) : super(key: key);

  final double sheetHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeIn,
        child: Container(
          height: sheetHeight,
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarColor,
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
            child: child,
          ),
        ),
      ),
    );
  }
}
