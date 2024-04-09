import 'package:flutter/foundation.dart';
import 'package:mvp_one/models/meal.dart';

enum MenuSource { newMenu, editMenu }

class MenuTitleProvider with ChangeNotifier {
  String _menuTitle = '';
  List<Meal> _meals = [];
  MenuSource _source = MenuSource.newMenu;

  String get menuTitle => _menuTitle;
  List<Meal> get meals => _meals;
  MenuSource get source => _source;

  void setMenuTitle(String title) {
    _menuTitle = title;
    notifyListeners();
  }

  void setMeals(List<Meal> meals) {
    _meals = meals;
    notifyListeners();
  }

  void setSource(MenuSource source) {
    _source = source;
    notifyListeners();
  }
}
