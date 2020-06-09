import 'package:flutter/material.dart';

class TwoLineListTile extends StatelessWidget {
  final String title;
  final String subtitle;

  final Widget leading;
  final Widget trailing;

  final Function() onTap;

  TwoLineListTile(
      {@required this.title,
      @required this.onTap,
      this.subtitle = '',
      this.leading,
      this.trailing,
    });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: leading,
      trailing: trailing,
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}

