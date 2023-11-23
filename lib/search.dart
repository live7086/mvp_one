import 'package:flutter/material.dart';
import 'User_menu_style.dart';

void main() {
  runApp(
    MaterialApp(
      home: Usermeun(),
    ),
  );
}

class Usermeun extends StatelessWidget {
  const Usermeun({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const SearchInput(),
          const DDD(),
          const mainpic(),
          const SizedBox(height: 35),
          const DDD(),
          MyBottomNavigationBar(),
        ],
      ),
    );
  }
}
