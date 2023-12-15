import 'package:flutter/material.dart';
import 'User_menu_style.dart';

class Usermeun extends StatelessWidget {
  const Usermeun({Key? key}) : super(key: key);

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
      body: const Column(
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
          MyBottomNavigationBar(),
        ],
      ),
    );
  }
}
