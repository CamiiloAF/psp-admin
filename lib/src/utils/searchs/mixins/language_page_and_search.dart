import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/languages_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/custom_list_tile.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';

class LanguagePageAndSearchMixing {
  BuildContext _context;
  GlobalKey<ScaffoldState> _scaffoldKey;

  void initializeMixing(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    context = context;
    _scaffoldKey = scaffoldKey;
  }

  Widget buildItemList(LanguageModel language) {
    return CustomListTile(
        title: language.name,
        trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => showDialogEditLanguage(language)),
        onTap: () {});
  }

  void showDialogEditLanguage(LanguageModel language) {
    final s = S.of(_context);
    final _dialogFormKey = GlobalKey<FormState>();

    showDialog(
        context: _context,
        builder: (context) => AlertDialog(
              title: Text(s.labelLanguage),
              actions: [
                OutlineButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(s.dialogButtonCancel),
                ),
                OutlineButton(
                  onPressed: () => _submit(language, _dialogFormKey),
                  child: Text(s.save),
                ),
              ],
              content: Form(
                  key: _dialogFormKey,
                  child: Container(
                    child: InputForm(
                      initialValue: language.name,
                      label: s.labelName,
                      maxLenght: 50,
                      validator: (value) =>
                          (value.isEmpty) ? s.inputRequiredError : null,
                      onSaved: (value) => language.name = value.trim(),
                    ),
                  )),
            ));
  }

  void _submit(
      LanguageModel language, GlobalKey<FormState> dialogFormKey) async {
    if (!dialogFormKey.currentState.validate()) return;
    final languagesBloc =
        Provider.of<BlocProvider>(_context, listen: false).languagesBloc;

    dialogFormKey.currentState.save();
    final progressDialog =
        getProgressDialog(_context, S.of(_context).progressDialogSaving);

    await progressDialog.show();

    var statusCode = -1;

    if (language.id == null) {
      statusCode = await languagesBloc.insertLanguage(language);
      await progressDialog.hide();
    } else {
      statusCode = await languagesBloc.updateLanguage(language);
      await progressDialog.hide();
    }

    if (statusCode == 201) {
      Navigator.pop(_context);
    } else {
      showSnackBar(_context, _scaffoldKey.currentState, statusCode);
    }
  }
}
