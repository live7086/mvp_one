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
  void _reorderSelectedMeal(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Meal selectedMeal = selectedMealsForCustomMenu.removeAt(oldIndex);
    selectedMealsForCustomMenu.insert(newIndex, selectedMeal);
  }

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
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
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
          ),
          Container(
            height: 100,
            color: Colors.grey[200],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedMealsForCustomMenu.length,
              itemBuilder: (context, index) {
                final selectedMeal = selectedMealsForCustomMenu[index];
                return _SelectedMealItem(
                  meal: selectedMeal,
                  onRemove: () {
                    setState(() {
                      selectedMealsForCustomMenu.remove(selectedMeal);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _completeSelection,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
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
            width: 3,
          ),
        ),
        elevation: isSelected ? 12 : 4,
        margin: const EdgeInsets.all(0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                image: meal.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  meal.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectedMealItem extends StatelessWidget {
  final Meal meal;
  final VoidCallback onRemove;

  const _SelectedMealItem({
    Key? key,
    required this.meal,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: meal.imageUrl,
              width: 80,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
