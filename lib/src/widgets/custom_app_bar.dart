import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SearchDelegate searchDelegate;

  CustomAppBar({this.searchDelegate});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).appBarTitleProjects),
      actions: appBarActions(context),
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: searchDelegate);
          }),
      PopupMenuButton(
          onSelected: (value) => onItemMenuSelected(value, context),
          itemBuilder: (context) => getPopUpMenuOptions(context).map((option) {
                PopupMenuItem<String>(value: option, child: Text(option));
              }).toList())
    ];
  }

  List<String> getPopUpMenuOptions(BuildContext context) => [
        S.of(context).optionSettings,
        S.of(context).optionLogOut,
      ];

  void onItemMenuSelected(String value, BuildContext context) {
    final options = getPopUpMenuOptions(context);

    if (value == options[0]) {
    } else if (value == options[1]) {}
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
