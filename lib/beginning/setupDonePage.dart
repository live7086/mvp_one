import 'package:flutter/material.dart';
import 'package:mvp_one/search.dart';
import 'package:mvp_one/slidePageAnimation.dart';

class SetupDonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Handle button tap here
          Navigator.pushNamed(context, '/tabscreen');
        },
        child: Stack(
          children: [
            // 背景圖片
            Positioned.fill(
              child: Image.asset(
                'assets/setupDone.png',
                fit: BoxFit.cover,
              ),
            ),
            // 其他頁面內容可以在這裡添加
          ],
        ),
      ),
    );
  }
}
