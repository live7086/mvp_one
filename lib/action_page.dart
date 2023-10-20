import 'package:flutter/material.dart';

class ActionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("動作頁面")),
      body: Padding(
        padding: EdgeInsets.all(16.0), // 在整個內容周圍添加16像素的padding
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0, // 水平距離
            mainAxisSpacing: 10.0,  // 垂直距離
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // 導航到介紹頁面
                Navigator.pushNamed(context, '/intro'); // 導航到動作頁面
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
