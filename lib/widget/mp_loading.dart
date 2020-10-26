import 'package:flutter/material.dart';

class MPLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).primaryColor,
      ),
    );
  }
}
