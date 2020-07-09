import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/validators/validators.dart';
import 'package:psp_admin/src/repositories/session_repository.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';

class RestorePasswordDialog extends StatefulWidget {
  final bool isByEmail;
  final SessionRepository sessionProvider;
  final GlobalKey<ScaffoldState> scaffoldKey;

  RestorePasswordDialog(
      {@required this.isByEmail, this.sessionProvider, this.scaffoldKey});

  @override
  _RestorePasswordDialogState createState() => _RestorePasswordDialogState();
}

class _RestorePasswordDialogState extends State<RestorePasswordDialog>
    with Validators {
  final _dialogFormKey = GlobalKey<FormState>();

  String _email;

  String _phone;
  String _countryCode = '+57';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return AlertDialog(
        title: Text(s.labelRestorePassword),
        actions: _buildDialogOptions(context, s),
        content: Form(
            key: _dialogFormKey, child: Container(child: _buidlInputForm())));
  }

  Widget _buidlInputForm() {
    return (widget.isByEmail)
        ? InputEmail(
            onSaved: (value) => _email = value,
            withIcon: false,
            hasError: false,
            validator: (value) => (Validators.isValidEmail(value)
                ? null
                : S.of(context).invalidEmail),
          )
        : InputPhoneWithCountryPicker(
            countryCode: '+57',
            onChangeCountryPicker: (countryCode) =>
                _countryCode = countryCode.dialCode,
            onSaved: (value) => _phone = value,
            validator: (value) => (isValidPhoneNumber(value)
                ? null
                : S.of(context).inputPhoneError),
          );
  }

  List<Widget> _buildDialogOptions(BuildContext context, S s) {
    return [
      OutlineButton(
        onPressed: () => Navigator.pop(context),
        child: Text(s.dialogButtonCancel),
      ),
      Builder(
        builder: (ctx) => OutlineButton(
          onPressed: () => _submit(ctx),
          child: Text(s.dialogButtonRecover),
        ),
      ),
    ];
  }

  void _submit(BuildContext ctx) async {
    if (!_dialogFormKey.currentState.validate()) return;

    _dialogFormKey.currentState.save();

    final s = S.of(context);

    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    var statusCode = -1;

    statusCode = (widget.isByEmail)
        ? await widget.sessionProvider.restorePasswordByEmail(_email)
        : await widget.sessionProvider
            .restorePasswordByPhone('$_countryCode-$_phone');

    await progressDialog.hide();

    if (statusCode == 204) {
      final snackbarMessage = (widget.isByEmail)
          ? s.messageWeHaveSentEmail
          : s.messageWeHaveSentSMS;

      final snackbar = buildSnackbar(snackbarMessage);
      widget.scaffoldKey.currentState.showSnackBar(snackbar);
    } else {
      final snackbar =
          buildSnackbar(getRequestResponseMessage(context, statusCode));
      widget.scaffoldKey.currentState.showSnackBar(snackbar);
    }
    Navigator.pop(context);
  }
}
