import 'package:rxdart/rxdart.dart';

import 'Validators.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get formValidateStream =>
      Observable.combineLatest2(emailStream, passwordStream, (es, ps) => true);

  // Insertar valores al Stream
  Function(String) get onEmailChange => _emailController.sink.add;
  Function(String) get onPasswordChange => _passwordController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
