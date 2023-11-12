import 'package:flutter/material.dart';

class GenderSelectionPage extends StatefulWidget {
  @override
  _GenderSelectionPageState createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  String selectedGender = '';

  void selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("選擇性別")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GenderImage(
                  imagePath: 'assets/male.png',
                  gender: '男生',
                  onSelect: () => selectGender('男生'),
                ),
                SizedBox(width: 20),
                GenderImage(
                  imagePath: 'assets/female.png',
                  gender: '女生',
                  onSelect: () => selectGender('女生'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              selectedGender.isEmpty ? '請選擇性別' : '您選擇的性別是：$selectedGender',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/action');
              },
              child: Text("下一步"),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderImage extends StatelessWidget {
  final String imagePath;
  final String gender;
  final VoidCallback onSelect;

  GenderImage({
    required this.imagePath,
    required this.gender,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
          ),
          SizedBox(height: 10),
          Text(
            gender,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GenderSelectionPage(),
  ));
}
