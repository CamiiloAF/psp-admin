import 'package:flutter/material.dart';

class TabModel with ChangeNotifier {
  SearchDelegate _searchDelegate;

  SearchDelegate get searchDelegate => _searchDelegate;

  set searchDelegate(SearchDelegate value) {
    _searchDelegate = value;
    notifyListeners();
  }
}
