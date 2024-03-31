import 'package:flutter/material.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/data/dummy_data.dart';
import 'package:mvp_one/widgets/meal_item.dart';

class ActionSelectionPage extends StatefulWidget {
  final List<Meal> selectedMeals;

  ActionSelectionPage({required this.selectedMeals});

  @override
  _ActionSelectionPageState createState() => _ActionSelectionPageState();
}

class _ActionSelectionPageState extends State<ActionSelectionPage> {
  List<Meal> availableMeals = dummyMeals;
  String menuTitle = '';
  String menuDescription = '';

  void _completeSelection() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('新增菜單'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '菜單名稱'),
                onChanged: (value) {
                  setState(() {
                    menuTitle = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '介紹文字'),
                onChanged: (value) {
                  setState(() {
                    menuDescription = value;
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
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, {
                  'selectedMeals': widget.selectedMeals,
                  'menuTitle': menuTitle,
                  'menuDescription': menuDescription,
                });
              },
              child: Text('完成'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('選擇動作'),
      ),
      body: ListView.builder(
        itemCount: availableMeals.length,
        itemBuilder: (context, index) {
          final meal = availableMeals[index];
          return MealItem(
            meal: meal,
            onSelectMeal: (selectedMeal) {
              setState(() {
                if (widget.selectedMeals.contains(selectedMeal)) {
                  widget.selectedMeals.remove(selectedMeal);
                } else {
                  widget.selectedMeals.add(selectedMeal);
                }
              });
            },
            isSelected: widget.selectedMeals.contains(meal),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _completeSelection,
        child: Text('完成'),
      ),
    );
  }
}
