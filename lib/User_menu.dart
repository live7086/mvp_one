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
          SizedBox(height: 60),
          Divider(
            color: Color.fromARGB(255, 111, 110, 110),
            thickness: 1,
          ),
          Usertitle(),
          Usersecond(),
          Divider(
            color: Color.fromARGB(255, 111, 110, 110),
            thickness: 1,
          ),
          SizedBox(height: 60),
          UserStyle(),
        ],
      ),
    );
  }
}
