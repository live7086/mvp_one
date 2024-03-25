import 'package:flutter/material.dart';
import 'package:mvp_one/screens/move.dart';

class ResultPage extends StatelessWidget {
  final int duration;

  ResultPage({required this.duration});

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
                Navigator.pop(context);
              },
              child: Text('返回餐點列表'),
            ),
          ],
        ),
      ),
    );
  }
}
