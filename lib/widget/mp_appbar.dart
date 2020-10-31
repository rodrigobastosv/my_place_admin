import 'package:flutter/material.dart';
import 'package:my_place/widget/mp_button_icon.dart';

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
          leadingWidth: 40,
          leading: !withLeading
              ? null
              : MPButtonIcon(
                  iconData: Icons.chevron_left,
                  onTap: () => Navigator.pop(context),
                ),
          actions: actions,
        ),
      ),
    );
  }
}
