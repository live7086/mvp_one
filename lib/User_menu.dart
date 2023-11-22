import 'package:flutter/material.dart';
import 'User_meun_style.dart';

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
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 80),
          DDD(),
          Usertitle(),
          Usersecond(),
          DDD(),
          SizedBox(height: 60),
          UserStyle(),
          SizedBox(height: 170),
          DDD(),
        ],
      ),
    );
  }
}
