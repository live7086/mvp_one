import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mvp_one/data/dummy_data.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/customize_menu/menu_move_result.dart';
import 'package:mvp_one/customize_menu/menu_resume.dart';
import 'package:mvp_one/pose.dart';

class MenuCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final List<Meal> selectedMeals;
  final List<int> mealCounts;
  final void Function(Meal meal) onToggleFavorite;

  const MenuCameraScreen({
    Key? key,
    required this.cameras,
    required this.selectedMeals,
    required this.mealCounts,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  MenuCameraScreenState createState() => MenuCameraScreenState();
}

class CustomMenuItem {
  final String name;
  final String description;
  final String iconPath;
  final String mealId;

  CustomMenuItem({
    required this.name,
    required this.description,
    required this.iconPath,
    required this.mealId,
  });
}

List<CustomMenuItem> getCustomMenuItems() {
  List<CustomMenuItem> customMenuItems = [];

  for (var meal in dummyMeals) {
    customMenuItems.add(
      CustomMenuItem(
        name: meal.title,
        description: '描述或其他相關資訊',
        iconPath: 'assets/icons/menu_item_icon.png',
        mealId: meal.id,
      ),
    );
  }

  return customMenuItems;
}

class MenuCameraScreenState extends State<MenuCameraScreen>
    with WidgetsBindingObserver {
  bool _isResuming = false;
  late Meal meal;
  bool _isAllPosesCompleted = false;
  int currentMealIndex = 0;
  int currentMealCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    meal = widget.selectedMeals[currentMealIndex];
    currentMealCount = widget.mealCounts[currentMealIndex];
  }

  @override
  Widget build(BuildContext context) {
    return CameraScreen(
      cameras: widget.cameras,
      meal: meal,
      onToggleFavorite: widget.onToggleFavorite,
      customMenuItems: getCustomMenuItems(),
      onPoseCompleted: _onPoseCompleted,
    );
  }

  void _onPoseCompleted() {
    setState(() {
      _isAllPosesCompleted = true;
    });
    _navigateToResultPage();
  }

  void _navigateToResultPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MenuResultPage(
          duration: 0, // 替換為實際的運動時間
          selectedMeals: widget.selectedMeals,
          mealCounts: widget.mealCounts,
          onToggleFavorite: widget.onToggleFavorite,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      onAppBackground();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _isResuming = false;
      });
    }
  }

  void onAppBackground() {
    if (!_isResuming) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: MealResumePage(
                meal: widget.selectedMeals,
                onResume: _resumeMeal,
              ),
            ),
          );
        },
      );
    }
  }

  void _resumeMeal() {
    _isResuming = true;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
