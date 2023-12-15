import 'package:flutter/material.dart';
import 'User_menu_style.dart';

class Usermenu extends StatelessWidget {
  const Usermenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Icon(Icons.account_circle),
      ),
      body: Stack(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DDD(),
              Usertitle("訓練菜單"),
              Usersecond(),
              DDD(),
              SizedBox(height: 60),
              UserStyle(),
              SizedBox(height: 150),
              DDD(),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 56, // 設定底部導航欄的高度
              child: const MyBottomNavigationBar(),
            ),
          ),
        ],
      ),
    );
  }
}
