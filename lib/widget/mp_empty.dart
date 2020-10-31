import 'package:flutter/material.dart';

class MPEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 100,
            color: Theme.of(context).primaryColorLight,
          ),
          Text(
            'Sem registros.',
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}
