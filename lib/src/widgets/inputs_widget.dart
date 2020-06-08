import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';

Widget inputEmail(
    BuildContext context, bool hasError, Function(String value) onChange) {
  return TextField(
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        icon: Icon(Icons.email, color: Theme.of(context).primaryColor),
        hintText: S.of(context).hintEmail,
        labelText: S.of(context).labelEmail,
        errorText: (hasError) ? S.of(context).invalidEmail : null
    ),
    onChanged: onChange,
  );
}

Widget inputPassword(
    BuildContext context, bool hasError, Function(String value) onChange) {
  return TextField(
    obscureText: true,
    decoration: InputDecoration(
        icon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).primaryColor,
        ),
        labelText: S.of(context).labelPassword,
        errorText: (hasError) ? S.of(context).invalidPassword : null
    ),
    onChanged: onChange,
  );
}
