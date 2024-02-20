import 'package:flutter/material.dart';
import 'package:mvp_one/training_plus.dart';
import 'User_menu_style.dart';
import 'Training_plus.dart';
import 'package:mvp_one/slidePageAnimation.dart';

class Training_Menu extends StatelessWidget {
  const Training_Menu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('訓練菜單'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('主要內容'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
