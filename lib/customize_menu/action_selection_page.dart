import 'package:flutter/material.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/data/dummy_data.dart';
import 'package:mvp_one/provider/provider.dart';
import 'package:provider/provider.dart';

class ActionSelectionPage extends StatefulWidget {
  final List<Meal> selectedMealsForCustomMenu;

  const ActionSelectionPage(
      {super.key, required this.selectedMealsForCustomMenu});

  @override
  _ActionSelectionPageState createState() => _ActionSelectionPageState();
}

class _ActionSelectionPageState extends State<ActionSelectionPage> {
  List<Meal> availableMeals = dummyMeals; // 可選擇的動作列表
  List<Meal> selectedMealsForCustomMenu = []; // 為自定義菜單選擇的餐點列表
  String customMenuTitle = ''; // 自定義菜單標題
  String customMenuDescription = ''; // 自定義菜單描述

  @override
  void initState() {
    super.initState();
    selectedMealsForCustomMenu = List.from(widget.selectedMealsForCustomMenu);

    // 從provider中獲取已選擇的meals
    final meals = Provider.of<MenuTitleProvider>(context, listen: false).meals;
    selectedMealsForCustomMenu = List.from(meals);
  }

  @override
  void didUpdateWidget(covariant ActionSelectionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMealsForCustomMenu !=
        oldWidget.selectedMealsForCustomMenu) {
      selectedMealsForCustomMenu = List.from(widget.selectedMealsForCustomMenu);
    }

    // 從provider中獲取已選擇的meals
    final meals = Provider.of<MenuTitleProvider>(context, listen: false).meals;
    selectedMealsForCustomMenu = List.from(meals);
  }

  // 完成動作選擇
  void _completeSelection() async {
    Provider.of<MenuTitleProvider>(context, listen: false)
        .setMeals(selectedMealsForCustomMenu);

    if (Provider.of<MenuTitleProvider>(context, listen: false).source ==
        MenuSource.newMenu) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('新增自定義菜單'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: '菜單名稱'),
                  onChanged: (value) {
                    setState(() {
                      customMenuTitle = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: '介紹文字'),
                  onChanged: (value) {
                    setState(() {
                      customMenuDescription = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context, {
                    'selectedMeals': selectedMealsForCustomMenu,
                    'menuTitle': customMenuTitle,
                    'menuDescription': customMenuDescription,
                  });
                },
                child: const Text('完成'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context, {
        'selectedMeals': selectedMealsForCustomMenu,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('選擇動作'),
      ),
      body: ListView.builder(
        itemCount: availableMeals.length,
        itemBuilder: (context, index) {
          final meal = availableMeals[index];
          return _MealItem(
            meal: meal,
            isSelected: selectedMealsForCustomMenu.contains(meal),
            onSelectMeal: (selectedMeal) {
              setState(() {
                if (selectedMealsForCustomMenu.contains(selectedMeal)) {
                  selectedMealsForCustomMenu.remove(selectedMeal);
                } else {
                  selectedMealsForCustomMenu.add(selectedMeal);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _completeSelection,
        child: const Icon(Icons.check),
      ),
    );
  }
}

class _MealItem extends StatelessWidget {
  final Meal meal;
  final bool isSelected;
  final ValueChanged<Meal> onSelectMeal;

  const _MealItem({
    Key? key,
    required this.meal,
    required this.isSelected,
    required this.onSelectMeal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelectMeal(meal);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    meal.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      meal.title,
                      style: const TextStyle(fontSize: 26, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
