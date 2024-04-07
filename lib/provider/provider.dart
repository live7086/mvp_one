import 'package:flutter/foundation.dart';

class MenuTitleProvider with ChangeNotifier {
  String _menuTitle = '';

  String get menuTitle => _menuTitle;

  void setMenuTitle(String title) {
    _menuTitle = title;
    notifyListeners();
  }
}
