import 'package:flutter/material.dart';
import 'package:mvp_one/User_menu.dart';
import 'package:mvp_one/model.dart';
import 'package:mvp_one/screens/tabs.dart';
import 'package:mvp_one/search.dart';
import 'package:mvp_one/slidePageAnimation.dart';
import 'package:mvp_one/posePage.dart';
import 'package:mvp_one/widget_expense/expenses.dart';

void onPressed() {}

class UserStyle extends StatelessWidget {
  const UserStyle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 185, 185, 185),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextButton(
            onPressed: onPressed,
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
            child: const Text('初階菜單'),
          ),
        ),
        const SizedBox(height: 60), // Adjust the spacing between buttons
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 185, 185, 185),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextButton(
            onPressed: onPressed,
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
            child: const Text('中階菜單'),
          ),
        ),
        const SizedBox(height: 60), // Adjust the spacing between buttons
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 185, 185, 185),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextButton(
            onPressed: onPressed,
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
            child: const Text('高階菜單'),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}

class Usertitle extends StatelessWidget {
  final String title;
  const Usertitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Usersecond extends StatelessWidget {
  const Usersecond({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const TextButton(
            onPressed: onPressed,
            child: Text(
              '推薦',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              '自訂菜單',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 173, 172, 172)),
            ),
          ),
        ],
      ),
    );
  }
}

class DDD extends StatelessWidget {
  const DDD({super.key});
  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1.5,
      color: Color.fromARGB(255, 138, 136, 136),
    );
  }
}

class SearchInput extends StatefulWidget {
  const SearchInput({Key? key}) : super(key: key);
  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 25, right: 25),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: TextField(
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 209, 208, 208),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      hintText: 'Search',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 18),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(10),
                        width: 15,
                        child: Image.asset('assets/search_icon.jpg'),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class mainpic extends StatelessWidget {
  const mainpic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(SlidePageRoute(page: const model_1()));
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/yoga_1.jpg',
              fit: BoxFit.cover,
              width: 350,
              height: 180,
            ),
          ),
        ),
        const SizedBox(height: 15), // Adjust the spacing between buttons
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(SlidePageRoute(page: HorizontalScrollListPage()));
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/yoga_2.jpg',
              fit: BoxFit.cover,
              width: 350,
              height: 180,
            ),
          ),
        ),

        const SizedBox(height: 15), // Adjust the spacing between buttons
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(SlidePageRoute(page: HorizontalScrollListPage()));
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/yoga_3.jpg',
              fit: BoxFit.cover,
              width: 350,
              height: 180,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

//用不到的範例
class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
    );
  }
}

//底下導引列
class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 242, 243, 243),
        border: Border(
          top: BorderSide(
            color: Colors.grey, // 定義頂部邊框顏色
            width: 1.0, // 定義頂部邊框寬度
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(SlidePageRoute(page: const Search()));
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fitness_center),
                Text('訓練'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(SlidePageRoute(page: const Usermenu()));
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book),
                Text('訓練菜單'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(SlidePageRoute(page: const TabsScreen()));
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.file_copy_sharp),
                Text('歷史紀錄'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(SlidePageRoute(page: const Expenses()));
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person),
                Text('關於我'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
