import 'dart:async';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (isValidEmail(email)) {
      sink.add(email);
    } else {
      sink.addError('Error');
    }
  });

  static bool isValidEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    var regExp = RegExp(pattern);
    return regExp.hasMatch(email) ? true : false;
  }

  bool isValidPhoneNumber(String phoneNumber) =>
      (phoneNumber.length >= 10) ? true : false;

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (isValidPassword(password)) {
      sink.add(password);
    } else {
      sink.addError('Error');
    }
  });

  static bool isValidPassword(String password) =>
      (password.length >= 8) ? true : false;

  bool isValidConfirmPassword(String password, String confirmPassword) =>
      (password != null &&
              isValidPassword(password) &&
              password == confirmPassword)
          ? true
          : false;
}
