import 'package:flutter/material.dart';

class MPListView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const MPListView({this.itemCount, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: ListView.separated(
        separatorBuilder: (_, int index) => Divider(
          height: 1,
          indent: 68,
        ),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
