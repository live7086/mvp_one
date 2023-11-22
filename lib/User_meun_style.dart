import 'package:flutter/material.dart';

void onPressed() {
  print("就還沒寫完按三小");
}

class UserStyle extends StatelessWidget {
  const UserStyle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 185, 185, 185),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Text('初階菜單'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(
                right: 80,
                left: 80,
              ),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              textStyle: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 60), // Adjust the spacing between buttons
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 185, 185, 185),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Text('中階菜單'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(
                right: 80,
                left: 80,
              ),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              textStyle: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 60), // Adjust the spacing between buttons
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 185, 185, 185),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Text('高階菜單'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(
                right: 80,
                left: 80,
              ),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              textStyle: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            right: 132,
            left: 132,
          ),
        ),
      ],
    );
  }
}

class Usertitle extends StatelessWidget {
  const Usertitle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        '訓練菜單',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
