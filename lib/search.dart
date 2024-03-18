import 'package:flutter/material.dart';
import 'User_menu_style.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  SearchInput(),
                  DDD(),
                  mainpic(),
                  SizedBox(height: 35),
                  // Add other content here
                ],
              ),
            ],
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 56, // 設定底部導航欄的高度
              child: MyBottomNavigationBar(),
            ),
          ),
        ],
      ),
    );
  }
}
