import 'package:flutter/material.dart';

class MPAppBar extends PreferredSize {
  final Widget title;
  final bool withLeading;
  final List<Widget> actions;

  MPAppBar({
    this.title,
    this.withLeading = true,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        child: AppBar(
          title: title,
          leading: !withLeading
              ? null
              : IconButton(
                  icon: Icon(Icons.chevron_left),
                  iconSize: 32,
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                ),
          actions: actions,
        ),
      ),
    );
  }
}
