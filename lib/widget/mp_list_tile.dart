import 'package:flutter/material.dart';

class MPListTile extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final Widget title;
  final Function onTap;

  const MPListTile({
    this.leading,
    this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      visualDensity: VisualDensity.compact,
      leading: leading == null
          ? null
          : Container(
              alignment: Alignment.center,
              width: 36,
              child: leading,
            ),
      title: title,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
