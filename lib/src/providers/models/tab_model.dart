import 'package:flutter/material.dart';

class TabModel with ChangeNotifier {
  SearchDelegate _searchDelegate;

  int hola = 1;

  SearchDelegate get searchDelegate => _searchDelegate;

  set searchDelegate(SearchDelegate value) {
    _searchDelegate = value;
    hola++;
    notifyListeners();
  }
}
