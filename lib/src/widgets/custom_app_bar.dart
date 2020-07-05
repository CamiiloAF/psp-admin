import 'package:flutter/material.dart';

import 'custom_popup_menu.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SearchDelegate searchDelegate;
  final String title;
  final PreferredSizeWidget bottom;
  final Function(int value) onThenShowSearch;

  CustomAppBar({this.searchDelegate, @required this.title, this.bottom, this.onThenShowSearch});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: appBarActions(context),
      bottom: bottom,
    );
  }

  List<Widget> appBarActions(BuildContext context) {
    return [
      (searchDelegate != null)
          ? IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: searchDelegate).then((value) => (onThenShowSearch != null)? onThenShowSearch(value) : null);
              })
          : Container(),
      CustomPopupMenu()
    ];
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0));
}
