import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/Validators.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/utils.dart';
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

  String confirmPassword;

  String countryCode;

  bool inputEmailHasError = false;
  bool inputPhoneHasError = false;
  bool inputPasswordHasError = false;
  bool inputConfirmPasswordHasError = false;

  bool isAdmin;

  @override
  Widget build(BuildContext context) {
    _usersBloc = Provider.of<BlocProvider>(context).usersBloc;

    // [0] is UserModel - [1] is projectId
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;

    final int projectId = arguments[1];

    if (arguments[0] != null) {
      _userModel = arguments[0];
    }

    isAdmin = (_userModel.rol == 'ADMIN') ? true : false;

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
              _buildInputEmail(),
              _buildInputPhoneWithCountryPicker(),
              _buildInputPassword(),
              _buildInputConfirmPassword(),
              _buildCheckboxIsAdmin(),
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

  InputEmail _buildInputEmail() {
    return InputEmail(
      initialValue: _userModel.email,
      withIcon: false,
      hasError: inputEmailHasError,
      onChange: (value) {
        setState(() {});
        inputEmailHasError = Validators.isValidEmail(value) ? false : true;
      },
      validator: (value) =>
          Validators.isValidEmail(value) ? null : S.of(context).invalidEmail,
      onSaved: (value) => _userModel.email = value,
    );
  }

  InputPhoneWithCountryPicker _buildInputPhoneWithCountryPicker() {
    // [0] is county code - [1] is phoneNumber
    final phoneNumberAndCountryCode =
        _userModel.phone != null && _userModel.phone.isNotEmpty
            ? _userModel.phone.split('-')
            : ['+57', ''];

    _initializeGlobalCountryCode(phoneNumberAndCountryCode[0]);

    return InputPhoneWithCountryPicker(
      hasError: inputPhoneHasError,
      initialValue: phoneNumberAndCountryCode[1],
      countryCode: phoneNumberAndCountryCode[0],
      onChangeCountryPicker: (value) => countryCode = value.dialCode,
      onChange: (value) {
        setState(() {
          inputPhoneHasError =
              _usersBloc.isValidPhoneNumber(value) ? false : true;
        });
      },
      validator: (value) => _usersBloc.isValidPhoneNumber(value)
          ? null
          : S.of(context).inputPhoneError,
      onSaved: (value) => _userModel.phone = '$countryCode-$value',
    );
  }

  Widget _buildInputPassword() {
    if (_userModel.id != null) return Container();

    return InputPassword(
      withIcon: false,
      hasError: inputPasswordHasError,
      onChange: (value) {
        setState(() {
          _userModel.password = value;
          inputPasswordHasError =
              (Validators.isValidPassword(value)) ? false : true;

          if (!inputPasswordHasError) {
            inputConfirmPasswordHasError = (_usersBloc.isValidConfirmPassword(
                    _userModel.password, confirmPassword))
                ? false
                : true;
          }
        });
      },
      validator: (value) => (Validators.isValidPassword(value))
          ? null
          : S.of(context).invalidPassword,
      onSaved: (value) => _userModel.password = value,
    );
  }

  Widget _buildInputConfirmPassword() {
    if (_userModel.id != null) return Container();

    return InputPassword(
      withIcon: false,
      hasError: inputConfirmPasswordHasError,
      errorText: S.of(context).invalidConfirmPassword,
      label: S.of(context).labelConfirmPassword,
      onChange: (value) {
        setState(() {
          confirmPassword = value;
          inputConfirmPasswordHasError =
              (_usersBloc.isValidConfirmPassword(_userModel.password, value))
                  ? false
                  : true;
        });
      },
      validator: (value) =>
          (_usersBloc.isValidConfirmPassword(_userModel.password, value))
              ? null
              : S.of(context).invalidConfirmPassword,
    );
  }

  Widget _buildCheckboxIsAdmin() {
    if (_userModel.id == json.decode(Preferences().curentUser)['id']) {
      return Container();
    }

    return CheckboxListTile(
      value: isAdmin,
      onChanged: (value) {
        setState(() {
          isAdmin = value;
        });
      },
      title: Text(S.of(context).titleIsAdmin),
    );
  }

  void _initializeGlobalCountryCode(String countryCode) =>
      this.countryCode = countryCode;

  void _submit(int projectId) async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    _userModel.rol = isAdmin ? 'ADMIN' : 'DEV';

    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    var statusCode = -1;

    if (_userModel.id == null) {
      statusCode = await _usersBloc.insertUser(_userModel, projectId);
      await progressDialog.hide();
    } else {
      statusCode = await _usersBloc.updateUser(_userModel);
      await progressDialog.hide();
    }

    if (statusCode == 201) {
      Navigator.pop(context);
    } else {
      showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }
}
