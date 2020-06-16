import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';

class UserEditPage extends StatefulWidget {
  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  UsersBloc _usersBloc;
  UserModel _userModel = UserModel();

  int _inputFirstNameCounter = 0;
  String _inputFirstNameError;

  int _inputLastNameCounter = 0;
  String _inputLastNameError;

  @override
  Widget build(BuildContext context) {
    _usersBloc = Provider.of<BlocProvider>(context).usersBloc;

    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;

    final int projectId = arguments[1];

    if (arguments[0] != null) {
      _userModel = arguments[0];
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(S.of(context).appBarTitleUsers),
      ),
      body: _createBody(projectId),
    );
  }

  Widget _createBody(int projectId) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildInputName(true),
              _buildInputName(false),
              InputEmail(
                withIcon: false,
                hasError: false,
                onChange: (value) {},
              ),
              InputPhoneWithCountryPicker(),
              InputPassword(
                withIcon: false,
                hasError: false,
              ),
              SizedBox(
                height: 20,
              ),
              InputPassword(
                withIcon: false,
                hasError: false,
                label: S.of(context).labelConfirmPassword,
              ),
              SizedBox(
                height: 20,
              ),
              SwitchListTile(
                value: false,
                onChanged: (value) {},
                title: Text('¿Es administrador?'),
              ),
              SubmitButton(onPressed: () => _submit(projectId))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputName(bool isFirstName) {
    return InputName(
        initialValue:
            (isFirstName) ? _userModel.firstName : _userModel.lastName,
        errorText: (isFirstName) ? _inputFirstNameError : _inputLastNameError,
        labelHint: (isFirstName) ? null : S.of(context).labelLastName,
        counter: (isFirstName)
            ? _inputFirstNameCounter.toString()
            : _inputLastNameCounter.toString(),
        onChange: (value) {
          setState(() {});
          (isFirstName)
              ? _inputFirstNameCounter = value.length
              : _inputLastNameCounter = value.length;
          if (value.trim().length < 3) {
            (isFirstName)
                ? _inputFirstNameError = S.of(context).inputNameError
                : _inputLastNameError = S.of(context).inputNameError;
            return S.of(context).inputNameError;
          } else {
            (isFirstName)
                ? _inputFirstNameError = null
                : _inputLastNameError = null;
            return null;
          }
        },
        onSaved: (String value) => (isFirstName)
            ? _userModel.firstName = value.trim()
            : _userModel.lastName = value.trim());
  }

  void _submit(int projectId) async {
    // if (!_formKey.currentState.validate()) return;

    // _formKey.currentState.save();
    // final progressDialog =
    //     getProgressDialog(context, S.of(context).progressDialogSaving);

    // await progressDialog.show();

    // var statusCode = -1;

    // if (_userModel.id == null) {
    //   _userModel.projectsId = projectId;
    //   statusCode = await _usersBloc.insertUser(_userModel);
    //   await progressDialog.hide();
    // } else {
    //   statusCode = await _usersBloc.updateUser(_userModel);
    //   await progressDialog.hide();
    // }

    // if (statusCode == 201) {
    //   Navigator.pop(context);
    // } else {
    //   showSnackBar(context, _scaffoldKey.currentState, statusCode);
    // }
  }
}
