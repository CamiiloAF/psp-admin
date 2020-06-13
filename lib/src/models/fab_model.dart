import 'package:flutter/foundation.dart';

class FabModel with ChangeNotifier {
  bool _isShowing = true;

  bool get isShowing => _isShowing;

  set isShowing(bool valor) {
    _isShowing = valor;
    notifyListeners();
  }
}
