import 'package:flutter/material.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/screens/move.dart';
import 'package:mvp_one/screens/move_detail.dart';

class ResultPage extends StatelessWidget {
  final int duration;
  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;
  ResultPage(
      {required this.duration,
      required this.meal,
      required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('運動結果')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '恭喜您完成,總共運動了 ${duration ~/ 60} 分鐘',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealDetailsScreen(
                      meal: meal,
                      onToggleFavorite: onToggleFavorite,
                    ),
                  ),
                );
              },
              child: Text('返回動作列表'),
            ),
          ],
        ),
      ),
    );
  }
}
