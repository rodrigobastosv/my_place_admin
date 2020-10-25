import 'package:flutter/material.dart';

class MPListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Function onTap;

  const MPListTile({this.leading, this.title, this.onTap});

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
      trailing: Container(
        width: 16,
        child: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
        ),
      ),
      onTap: onTap,
    );
  }
}
