import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;

  final Widget leading;
  final Widget trailing;

  final Function() onTap;

  CustomListTile({
    @required this.title,
    @required this.onTap,
    this.subtitle = '',
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: ListTile(
        title: Text(title),
        leading: leading,
        trailing: trailing,
        subtitle: (subtitle.isNotEmpty)
            ? Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
