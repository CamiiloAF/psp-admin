import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/blocs/login_bloc.dart';
import 'package:psp_admin/src/pages/login/restore_password_dialog.dart';
import 'package:psp_admin/src/providers/bloc_provider.dart';
import 'package:psp_admin/src/repositories/session_repository.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/utils/utils.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';
import 'package:psp_admin/src/widgets/inputs_widget.dart';

class LoginPage extends StatelessWidget {
  final sessionProvider = SessionRepository();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _background(context),
            _loginForm(context),
          ],
        ));
  }

  Widget _background(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final backgroundColor = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        (Provider.of<ThemeChanger>(context).isDarkTheme)
            ? Colors.white.withOpacity(0)
            : Color(0xFF78909c),
        Theme.of(context).primaryColor
      ])),
    );

    final circle = Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05),
        ));

    return Stack(
      children: <Widget>[
        backgroundColor,
        Positioned(top: 90.0, left: 30.0, child: circle),
        Positioned(top: -40.0, right: -30.0, child: circle),
        Positioned(bottom: -50.0, right: -10.0, child: circle),
        Positioned(bottom: 120.0, right: 20.0, child: circle),
        Positioned(bottom: -50.0, left: -20.0, child: circle),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Container(width: 200, height: 200, child: _logo()),
                SizedBox(height: 10.0, width: double.infinity),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _logo() => (kIsWeb)
      ? Image.asset('assets/img/psp.png')
      : SvgPicture.asset('assets/svg/psp.svg');

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of<BlocProvider>(context).loginBloc;
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
              color: (isDarkTheme) ? Color(0xFF757575) : Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(0, 5),
                    spreadRadius: 3)
              ]),
          child: Column(
            children: <Widget>[
              Text(S.of(context).loginFormTitle,
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 10.0),
              _inputWithStreamBuilder(
                  context: context, bloc: bloc, isInputEmail: true),
              SizedBox(height: 20.0),
              _inputWithStreamBuilder(
                  context: context, bloc: bloc, isInputEmail: false),
              SizedBox(height: 20.0),
              _buttonWithStreamBuilder(context, bloc),
              SizedBox(height: 20.0),
              _buildRestorePasswordWidgets(context)
            ],
          ),
        )
      ],
    ));
  }

  Widget _inputWithStreamBuilder(
      {BuildContext context, LoginBloc bloc, bool isInputEmail}) {
    final stream = (isInputEmail) ? bloc.emailStream : bloc.passwordStream;

    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: (isInputEmail)
              ? InputEmail(
                  hasError: snapshot.hasError, onChange: bloc.onEmailChange)
              : InputPassword(
                  hasError: snapshot.hasError, onChange: bloc.onPasswordChange),
        ));
      },
    );
  }

  Widget _buttonWithStreamBuilder(BuildContext context, LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidateStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: raisedButton(context,
              buttonText: S.of(context).loginButton,
              onPress: () => _doLogin(bloc, context)),
        );
      },
    );
  }

  void _doLogin(LoginBloc bloc, BuildContext context) async {
    final progressDialog =
        getProgressDialog(context, S.of(context).progressDialogLoading);

    await progressDialog.show();
    Map response = await sessionProvider.doLogin(bloc.email, bloc.password);
    await progressDialog.hide();

    if (response['ok']) {
      await Navigator.pushReplacementNamed(context, 'projects');
    } else {
      String message;
      if (response['status'] == 7 ||
          response['status'] == Constants.TIME_OUT_EXCEPTION_CODE) {
        message = getRequestResponseMessage(context, response['status']);
      } else {
        message = S.of(context).messageIncorrectCredentials;
      }

      await progressDialog.hide();

      showAlertDialog(context,
          message: message, title: S.of(context).dialogTitleLoginFailed);
    }
  }

  Widget _buildRestorePasswordWidgets(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;
    final s = S.of(context);

    final textStyle = TextStyle(
      color: (isDarkTheme)
          ? Colors.white.withOpacity(0.6)
          : Theme.of(context).primaryColor,
    );

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showRestorePasswordDialog(context, true),
          child: Text(
            s.labelRestorePasswordByEmail,
            style: textStyle,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => _showRestorePasswordDialog(context, false),
          child: Text(
            s.labelRestorePasswordByPhoneNumber,
            style: textStyle,
          ),
        ),
      ],
    );
  }

  void _showRestorePasswordDialog(BuildContext context, bool isByEmail) {
    showDialog(
        context: context,
        builder: (context) => RestorePasswordDialog(
            isByEmail: isByEmail,
            sessionProvider: sessionProvider,
            scaffoldKey: _scaffoldKey));
  }
}
