import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/users_bloc.dart';
import 'package:psp_admin/src/blocs/validators/validators.dart';
import 'package:psp_admin/src/models/users_model.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';

class UserEditPage extends StatefulWidget {
  static const ROUTE_NAME = 'edit-user';

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _currentUserId = json.decode(Preferences().currentUser)['id'];

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
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    _usersBloc = Provider.of<BlocProvider>(context).usersBloc;

    // [0] is UserModel - [1] is projectId
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;

    final int projectId = arguments[1];

    if (arguments[0] != null) {
      _userModel = arguments[0];
    }

    isAdmin ??= (_userModel.rol == 'ADMIN') ? true : false;
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: S.of(context).appBarTitleUsers),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInputName(true),
              _buildInputName(false),
              _buildInputEmail(),
              _buildInputPhoneWithCountryPicker(),
              _buildInputPassword(),
              _buildInputConfirmPassword(),
              _buildCheckboxIsAdmin(),
              _buildFireUserButton(),
              SubmitButton(
                  onPressed: (_userModel.firstName != null &&
                          _userModel.organizationsId == null &&
                          _userModel.id != null)
                      ? null
                      : () => _submit(projectId))
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
    // * [0] is county code - [1] is phoneNumber
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
          : S.of(context).invalidNumber,
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
    if (_userModel.id == _currentUserId) {
      return Container();
    }

    return CheckboxListTile(
      value: isAdmin,
      activeColor: Theme.of(context).accentColor,
      onChanged: (value) {
        setState(() {
          isAdmin = value;
        });
      },
      title: Text(S.of(context).titleIsAdmin),
    );
  }

  Widget _buildFireUserButton() {
    if (_userModel.id == _currentUserId || _userModel.organizationsId == null) {
      return Container();
    }

    return CustomRaisedButton(
      buttonText: S.of(context).buttonFireUser,
      color: Theme.of(context).errorColor,
      paddingHorizontal: 0,
      paddingVertical: 0,
      onPressed: _fireUser,
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
      await showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }
  }

  void _fireUser() async {
    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogFiring);

    await progressDialog.show();

    _userModel.organizationsId = null;
    final statusCode = await _usersBloc.fireUser(_userModel);

    if (statusCode == 204) {
      setState(() {});
    } else {
      await showSnackBar(context, _scaffoldKey.currentState, statusCode);
    }

    await progressDialog.hide();
  }
}
