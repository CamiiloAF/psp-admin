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
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';
import 'package:psp_admin/src/widgets/not_autorized_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  UsersBloc _usersBloc;
  final UserModel _userModel = userModelFromJson(Preferences().curentUser);

  String countryCode;

  @override
  void initState() {
    super.initState();
    _usersBloc = context.read<BlocProvider>().usersBloc;
  }

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAutorizedScreen();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: S.of(context).appBarTitleProfile),
      body: _createBody(),
    );
  }

  Widget _createBody() {
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
              _buildChangePasswordText(),
              SubmitButton(onPressed: () => _submit())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordText() {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;

    return GestureDetector(
        onTap: _showChangePasswordDialog,
        child: Text(
          S.of(context).labelChangePassword,
          style: TextStyle(
              color:
                  (isDarkTheme) ? Colors.white : Theme.of(context).primaryColor,
              fontSize: 20),
        ));
  }

  Widget _buildInputName(bool isFirstName) {
    final s = S.of(context);

    return InputForm(
        initialValue:
            (isFirstName) ? _userModel.firstName : _userModel.lastName,
        maxLenght: 50,
        label: (isFirstName) ? s.labelName : s.labelLastName,
        validator: (value) =>
            (value.trim().length < 3) ? s.inputNameError : null,
        onSaved: (String value) => (isFirstName)
            ? _userModel.firstName = value.trim()
            : _userModel.lastName = value.trim());
  }

  InputEmail _buildInputEmail() {
    return InputEmail(
      initialValue: _userModel.email,
      withIcon: false,
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
      initialValue: phoneNumberAndCountryCode[1],
      countryCode: phoneNumberAndCountryCode[0],
      onChangeCountryPicker: (value) => countryCode = value.dialCode,
      validator: (value) => _usersBloc.isValidPhoneNumber(value)
          ? null
          : S.of(context).inputPhoneError,
      onSaved: (value) => _userModel.phone = '$countryCode-$value',
    );
  }

  void _initializeGlobalCountryCode(String countryCode) =>
      this.countryCode = countryCode;

  void _showChangePasswordDialog() {
    showDialog(
        context: context,
        builder: (context) => _ChangePasswordDialog(scaffoldKey: _scaffoldKey));
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    final statusCode = await _usersBloc.updateUser(_userModel);

    await progressDialog.hide();

    await showSnackBar(context, _scaffoldKey.currentState, statusCode);
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  _ChangePasswordDialog({this.scaffoldKey});

  @override
  __ChangePasswordDialogState createState() => __ChangePasswordDialogState();
}

class __ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _dialogFormKey = GlobalKey<FormState>();

  String password, confirmPassword;
  UsersBloc _usersBloc;

  @override
  void initState() {
    _usersBloc = context.read<BlocProvider>().usersBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return AlertDialog(
        title: Text(s.labelChangePassword),
        actions: _buildDialogOptions(context, s),
        useMaterialBorderRadius: true,
        content: Container(
            height: MediaQuery.of(context).size.height * 0.22,
            child: _buildForm(s)));
  }

  Widget _buildForm(S s) {
    return Form(
        key: _dialogFormKey,
        child: Column(
          children: [
            InputPassword(
              label: s.labelPassword,
              onChange: (value) => password = value.trim(),
              validator: (value) => (Validators.isValidPassword(value))
                  ? null
                  : s.invalidPassword,
              onSaved: (value) => password = value,
              withIcon: false,
            ),
            InputPassword(
              label: s.labelConfirmPassword,
              validator: (value) =>
                  (password == value) ? null : s.invalidConfirmPassword,
              onSaved: (value) => confirmPassword = value,
              withIcon: false,
            ),
          ],
        ));
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
          child: Text(s.labelChangePassword),
        ),
      ),
    ];
  }

  void _submit(BuildContext ctx) async {
    if (!_dialogFormKey.currentState.validate()) return;

    _dialogFormKey.currentState.save();

    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogSaving);

    await progressDialog.show();

    var statusCode = -1;

    final passwords = {
      'password': password,
      'confirmPassword': confirmPassword
    };

    statusCode = await _usersBloc.changePassword(passwords);

    await progressDialog.hide();
    await showSnackBar(context, widget.scaffoldKey.currentState, statusCode);
    Navigator.pop(context);
  }
}
