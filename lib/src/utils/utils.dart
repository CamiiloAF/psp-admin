import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/utils/constants.dart';

ProgressDialog getProgressDialog(BuildContext context, String message) {
  final progressDialog = ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);

  progressDialog.style(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    messageTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyText1.color),
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

String getRequestResponseMessage(S s, int statusCode) {
  switch (statusCode) {
  //7 = no connection
    case 7:
      return s.messageNotConnection;
      break;
    case 204:
      return s.message204Update;
      break;
    case 400:
      return s.message400;
      break;
    case 401:
      return s.message401;
      break;
    case 403:
      return s.message403;
      break;
    case 404:
      return s.message404;
      break;
    case 500:
      return s.message500;
      break;
    case Constants.TIME_OUT_EXCEPTION_CODE:
      return s.messageTimeOutException;
      break;
    case Constants.EMAIL_ALREADY_IN_USE:
      return s.messageEmailIsAlreadyInUse;
      break;
    case Constants.PHONE_ALREADY_IN_USE:
      return s.messagePhoneIsAlreadyInUse;
      break;
    default:
      return s.messageUnexpectedError;
  }
}

Future<void> showSnackBar(
  BuildContext context,
  ScaffoldState scaffoldState,
  int statusCode,
) async {
  if (statusCode != 404) {
    final snackBar =
        buildSnackbar(getRequestResponseMessage(S.of(context), statusCode));

    //Este delay es para que no genere un error. (Este error sólo se vé en la consola)
    await Future.delayed(Duration(milliseconds: 1));

    await scaffoldState.showSnackBar(snackBar);
  }
}

SnackBar buildSnackbar(String text, {durationInMilliseconds = 1500}) =>
    SnackBar(
      content: Text(text),
      duration: Duration(milliseconds: durationInMilliseconds),
    );

bool isNullOrEmpty(List list) => list == null || list.isEmpty;

int getMinutesBetweenTwoDates(DateTime startDate, DateTime finishDate) =>
    (startDate != null && finishDate != null)
        ? finishDate.difference(startDate).inMinutes
        : null;

bool isValidDates(DateTime date1, DateTime date2) {
  final difference = getMinutesBetweenTwoDates(date1, date2);

  return difference != null && difference >= 0;
}

void showSnackBarIncorrectDates(
  BuildContext context,
  ScaffoldState scaffoldState,
) {
  final snackBar = buildSnackbar(
      S.of(context).messageNoNegativeDifferenceBetweenDates,
      durationInMilliseconds: 3500);

  scaffoldState.showSnackBar(snackBar);
}
