import 'package:flutter/material.dart';

Widget raisedButton(BuildContext context, {String buttonText, Function onPress}) {
  return RaisedButton(
    child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
        child: Text(buttonText)
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    color: Theme.of(context).primaryColor,
    textColor: Colors.white,
    onPressed: onPress,
  );
}
