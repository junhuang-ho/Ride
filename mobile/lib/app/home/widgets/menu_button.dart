import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, this.onTap, required this.iconData})
      : super(key: key);

  final Function()? onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 44,
      left: 20,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 20,
            child: Icon(iconData),
          ),
        ),
      ),
    );
  }
}
