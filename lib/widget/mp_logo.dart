import 'package:flutter/material.dart';

class MPLogo extends StatelessWidget {
  final double fontSize;

  const MPLogo({this.fontSize = 40});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: fontSize/3.5),
          child: Text(
            'MyPlace',
            style: TextStyle(
              fontFamily: 'SansitaSwashed',
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Text(
            'admin',
            style: TextStyle(
              fontFamily: 'SansitaSwashed',
              fontSize: fontSize / 2.5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }
}
