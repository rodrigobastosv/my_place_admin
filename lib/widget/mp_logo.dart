import 'package:flutter/material.dart';

class MPLogo extends StatelessWidget {
  final double fontSize;

  const MPLogo({this.fontSize = 40});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'MyPlace ',
          style: TextStyle(
            fontFamily: 'SansitaSwashed',
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        TextSpan(
          text: ' ADMIN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ]),
    );
  }
}
