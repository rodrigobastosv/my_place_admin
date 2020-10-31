import 'package:flutter/material.dart';

class MPButtonIcon extends StatelessWidget {
  final IconData iconData;
  final Function onTap;

  const MPButtonIcon({
    @required this.iconData,
    @required this.onTap,
  })  : assert(iconData != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 40,
        height: 40,
        child: Icon(iconData),
      ),
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
    );
  }
}
