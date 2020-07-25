import 'package:psp_admin/src/pages/experiences/experiences_page.dart';
import 'package:psp_admin/src/pages/projects/projects_page.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/utils.dart' as utils;
import 'package:rxdart/rxdart.dart';

import 'experiences_bloc.dart';
import 'validators/validators.dart';

class LoginBloc with Validators {
  final preferences = Preferences();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  ExperiencesBloc _experiencesBloc;

  set experiencesBloc(ExperiencesBloc value) => _experiencesBloc = value;

  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get formValidateStream =>
      Rx.combineLatest2(emailStream, passwordStream, (es, ps) => true);

  Function(String) get onEmailChange => _emailController.sink.add;

  Function(String) get onPasswordChange => _passwordController.sink.add;

  String get email => _emailController.value;

  String get password => _passwordController.value;

  void addLoginAttemp() {
    final loginTries = preferences.loginAttemps;
    preferences.loginAttemps = loginTries + 1;

    _verifyLoginAttemps();
  }

  void _verifyLoginAttemps() {
    if (preferences.loginAttemps == 5) {
      preferences.loginLastAttempAt = DateTime.now().millisecondsSinceEpoch;
    }
  }

  void tryRestoreLoginAttemps() {
    final minutesBetweenLoginLastAttempAndNow =
        getMinutesBetweenLoginLastAttempAndNow();

    if (minutesBetweenLoginLastAttempAndNow > 60) {
      preferences.restoreLoginAttemps();
    }
  }

  int getMinutesBetweenLoginLastAttempAndNow() {
    final startDate =
        DateTime.fromMillisecondsSinceEpoch(preferences.loginLastAttempAt);

    return utils.getMinutesBetweenTwoDates(startDate, DateTime.now());
  }

  Future<String> getNextRouteName() async {
    final haveExperiences = await _experiencesBloc.haveExperience();

    if (haveExperiences == null) return null;

    return (haveExperiences)
        ? ProjectsPage.ROUTE_NAME
        : ExperiencesPage.ROUTE_NAME;
  }

  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
