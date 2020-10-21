import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double fontSize;

  const Logo({this.fontSize = 56});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Nosh',
      style: TextStyle(
        fontFamily: 'SansitaSwashed',
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
