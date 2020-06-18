import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;

  final Widget leading;
  final Widget trailing;

  final bool isEnable;

  final Function() onTap;

  CustomListTile({
    @required this.title,
    this.subtitle = '',
    this.leading,
    this.trailing,
    this.isEnable = true,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: ListTile(
        enabled: isEnable,
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
