// meals_screen.dart
import 'package:flutter/material.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/screens/move_detail.dart';
import 'package:mvp_one/widgets/meal_item.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    required this.onToggleFavorite,
  });

  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  // bool _isResuming = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // 應用程式進入背景時執行的函數
  //     onAppBackground();
  //   }
  // }

  // void onAppBackground() {
  //   if (!_isResuming) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return Center(
  //           child: Container(
  //             width: MediaQuery.of(context).size.width * 0.8,
  //             height: MediaQuery.of(context).size.height * 0.6,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //             child: MealResumePage(
  //               meal: widget.meals.first,
  //               // onToggleFavorite: widget.onToggleFavorite,
  //               onResume: _resumeMeal,
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
          onToggleFavorite: widget.onToggleFavorite,
        ),
      ),
    );
  }

  // void _resumeMeal() {
  //   _isResuming = true;
  //   Navigator.pop(context);
  // }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemBuilder: (ctx, index) => Text(widget.meals[index].title),
    );

    if (widget.meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh! nothing found!',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'try selecting another category',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ],
        ),
      );
    }

    if (widget.meals.isNotEmpty) {
      content = ListView.builder(
        itemCount: widget.meals.length,
        itemBuilder: (ctx, index) => MealItem(
          meal: widget.meals[index],
          onSelectMeal: (meal) {
            selectMeal(context, meal);
          },
          isSelected: false,
        ),
      );
    }

    if (widget.title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: content,
    );
  }
}
