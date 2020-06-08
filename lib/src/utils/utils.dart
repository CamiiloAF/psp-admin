import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:psp_admin/generated/l10n.dart';

ProgressDialog getProgressDialog(BuildContext context, String message) {
  final ProgressDialog progressDialog = ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);

  progressDialog.style(
    message: message,
  );

  return progressDialog;
}

void showAlertDialog(BuildContext context, {String message, String title}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).dialogButtonOk),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

String getMessageRequestFailed(BuildContext context, int code) {
  switch (code) {
    //7 = no connection
    case 7:
      return S.of(context).messageNotConnection;
      break;
    case 204:
      return S.of(context).message204Update;
      break;
    case 400:
      return S.of(context).message400;
      break;
    case 401:
      return S.of(context).message401;
      break;
    case 403:
      return S.of(context).message403;
      break;
    case 404:
      return S.of(context).message404;
      break;

    default:
  }
}
