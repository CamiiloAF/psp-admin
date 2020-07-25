import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/login_bloc.dart';
import 'package:psp_admin/src/pages/login/restore_password_text_buttons.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/repositories/session_repository.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';

import 'login_background.dart';

class LoginPage extends StatefulWidget {
  static const ROUTE_NAME = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final sessionProvider = SessionRepository();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final preferences = Preferences();
  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = context.read<BlocProvider>().loginBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (preferences.loginLastAttempAt != null) {
      _loginBloc.tryRestoreLoginAttemps();
    }

    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            LoginBackground(),
            _loginForm(context),
          ],
        ));
  }

  Widget _loginForm(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            height: 180,
          ),
        ),
        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 30),
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
              color: (isDarkTheme) ?Colors.white.withOpacity(0.1): Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(0, 5),
                    spreadRadius: 3)
              ]),
          child: _buildInputsAndButton(),
        )
      ],
    ));
  }

  Column _buildInputsAndButton() {
    return Column(
      children: <Widget>[
        Text(S.of(context).loginFormTitle, style: TextStyle(fontSize: 20)),
        SizedBox(height: 10.0),
        _inputWithStreamBuilder(isInputEmail: true),
        SizedBox(height: 20.0),
        _inputWithStreamBuilder(isInputEmail: false),
        SizedBox(height: 20.0),
        _buttonWithStreamBuilder(),
        SizedBox(height: 20.0),
        RestorePasswordTextButtons(
          scaffoldKey: _scaffoldKey,
          sessionProvider: sessionProvider,
        )
      ],
    );
  }

  Widget _inputWithStreamBuilder({bool isInputEmail}) {
    final stream =
        (isInputEmail) ? _loginBloc.emailStream : _loginBloc.passwordStream;

    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: (isInputEmail)
              ? InputEmail(
                  hasError: snapshot.hasError,
                  onChange: _loginBloc.onEmailChange)
              : InputPassword(
                  hasError: snapshot.hasError,
                  onChange: _loginBloc.onPasswordChange),
        ));
      },
    );
  }

  Widget _buttonWithStreamBuilder() {
    final isEnabled = preferences.loginLastAttempAt == null;

    return StreamBuilder(
      stream: _loginBloc.formValidateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: CustomRaisedButton(
              buttonText: S.of(context).loginButton,
              onPressed: (isEnabled && snapshot.hasData) ? () => _doLogin() : null),
        );
      },
    );
  }

  void _doLogin() async {
    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogLoading);

    await progressDialog.show();
    Map response =
        await sessionProvider.doLogin(_loginBloc.email, _loginBloc.password);

    if (response['ok']) {
      final routeName = await _loginBloc.getNextRouteName();
      if (routeName != null) {
        await Navigator.pushNamedAndRemoveUntil(
            context, routeName, (_) => false);
      }

      await progressDialog.hide();
      preferences.restoreLoginAttemps();
    } else {
      await progressDialog.hide();
      _badLogin(response['status']);
    }
  }

  void _badLogin(int responseStatus) async {
    if (responseStatus != 7 &&
        responseStatus != Constants.TIME_OUT_EXCEPTION_CODE) {
      _loginBloc.addLoginAttemp();
      setState(() {});
    }
    showAlertDialog(context,
        message: _getBadLoginMessage(context, responseStatus),
        title: S.of(context).dialogTitleLoginFailed);
  }

  String _getBadLoginMessage(BuildContext context, int responseStatus) {
    var message;

    message = (responseStatus == 7 ||
            responseStatus == Constants.TIME_OUT_EXCEPTION_CODE)
        ? getRequestResponseMessage(S.of(context), responseStatus)
        : S.of(context).messageIncorrectCredentials;

    if (preferences.loginAttemps == 5) {
      message +=
          '.\n\n' + S.of(context).messageExceededMaximumNumberSessionAttempts;
    }

    return message;
  }
}
