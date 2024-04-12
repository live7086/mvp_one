import 'package:flutter/material.dart';
import 'package:mvp_one/customize_menu/cus_menu.dart';
import 'package:mvp_one/data/dummy_data.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/provider/memory.dart';
import 'package:mvp_one/screens/categories.dart';
import 'package:mvp_one/screens/filters.dart';
import 'package:mvp_one/screens/move.dart';
import 'package:mvp_one/widgets/main_drawer.dart';

import '../user/UserInformationPage.dart';
import '../widget_expense/expenses.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
  Filter.time1: false,
  Filter.time2: false,
  Filter.level1: false,
  Filter.level2: false,
  Filter.level3: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  @override
  void initState() {
    super.initState();
    print("接收到的UID: ${widget.uid}");
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    void showInfoMessage(String message) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    if (isExisting == true) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      showInfoMessage('Meal is no longer a favorite');
      _favoriteMeals.remove(meal);
    } else {
      _favoriteMeals.add(meal);
      showInfoMessage('Marked as favorite');
    }
  }

  void _selectPage(int index) {
    switch (index) {
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomizeMenuPage(uid: widget.uid),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Expenses(
            uid: widget.uid,
          ),
        ));
        break;
      case 4:
        // 由于我们已经确保了 TabsScreen 接收了 uid，我们可以直接使用 widget.uid
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserInformationPage(uid: widget.uid),
        ));
        break;
      default:
        setState(() {
          _selectedPageIndex = index;
        });
        break;
    }
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'Filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_selectedFilters[Filter.time1]! && !meal.istime1) {
        return false;
      }
      if (_selectedFilters[Filter.time2]! && !meal.istime2) {
        return false;
      }
      if (_selectedFilters[Filter.level1]! && !meal.islevel1) {
        return false;
      }
      if (_selectedFilters[Filter.level2]! && !meal.islevel2) {
        return false;
      }
      if (_selectedFilters[Filter.level3]! && !meal.islevel3) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return MemoryProvider(
      uid: widget.uid,
      child: Scaffold(
        appBar: AppBar(
          title: Text(activePageTitle),
        ),
        drawer: MainDrawer(
          onSelectScreen: _setScreen,
        ),
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.set_meal),
              label: '動作菜單',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: '我的最愛',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: '自訂菜單',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_add_outlined),
              label: '訓練紀錄',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '設定',
            ),
          ],
        ),
      ),
    );
  }
}
