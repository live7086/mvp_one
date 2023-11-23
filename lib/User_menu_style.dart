import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.all(12.0),
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
          padding: const EdgeInsets.all(12.0),
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
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
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

class Usersecond extends StatelessWidget {
  const Usersecond({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
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
            onPressed: () {
              Navigator.pushNamed(context, '/userInfo');
            },
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
                        child: Image.asset('assets/search_icon.jpg'),
                        width: 15,
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
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              'assets/yoga_1.png',
              fit: BoxFit.cover,
              width: 350,
              height: 180,
            ),
          ),
        ),
        const SizedBox(height: 15), // Adjust the spacing between buttons
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12.0),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}
