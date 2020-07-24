import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';

class CustomRaisedButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final double paddingHorizontal;
  final double paddingVertical;

  final Color color;

  const CustomRaisedButton({
    this.buttonText,
    this.onPressed,
    this.paddingHorizontal = 80,
    this.paddingVertical = 15,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Text(buttonText)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: (color == null) ? Theme.of(context).primaryColor : color,
      textColor: Colors.white,
      onPressed: onPressed,
    );
  }
}

class FAB extends StatelessWidget {
  final String routeName;
  final Object arguments;
  final Function onPressed;

  const FAB({this.routeName, this.arguments, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (onPressed == null)
          ? () => Navigator.pushNamed(context, routeName, arguments: arguments)
          : onPressed,
      child: Icon(Icons.add),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final Function onPressed;

  const SubmitButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
      width: double.infinity,
      child: OutlineButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: theme.accentColor,
        highlightedBorderColor: theme.accentColor,
        textColor:
            (!isDarkTheme) ? Theme.of(context).accentColor : Colors.white,
        label: Text(S.of(context).save),
        icon: Icon(Icons.save),
        onPressed: onPressed,
      ),
    );
  }
}

class AlertDialogButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;

  const AlertDialogButton({this.onPressed, this.buttonText});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;

    return FlatButton(
      child: Text(buttonText),
      textColor: (isDarkTheme) ? Colors.white : Theme.of(context).accentColor,
      onPressed: onPressed,
    );
  }
}
