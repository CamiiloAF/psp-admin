import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';

class CustomRaisedButton extends StatelessWidget {
  final String buttonText;
  final Function onPress;
  final double paddingHorizontal;
  final double paddingVertical;
  final bool isEnabled;

  CustomRaisedButton({
    this.buttonText,
    this.onPress,
    this.paddingHorizontal = 80,
    this.paddingVertical = 15,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Text(buttonText)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: onPress,
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
      width: double.infinity,
      child: RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        label: Text(S.of(context).save),
        icon: Icon(Icons.save),
        onPressed: onPressed,
      ),
    );
  }
}
