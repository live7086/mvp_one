import 'package:flutter/material.dart';

class GenderSelectionPage extends StatefulWidget {
  @override
  _GenderSelectionPageState createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  String selectedGender = '';
  bool isMaleSelected = false;
  bool isFemaleSelected = false;

  void selectGender(String gender) {
    setState(() {
      if (gender == '男生') {
        isMaleSelected = true;
        isFemaleSelected = false;
      } else if (gender == '女生') {
        isMaleSelected = false;
        isFemaleSelected = true;
      }
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
                  isSelected: isMaleSelected,
                ),
                SizedBox(width: 40),
                GenderImage(
                  imagePath: 'assets/female.png',
                  gender: '女生',
                  onSelect: () => selectGender('女生'),
                  isSelected: isFemaleSelected,
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
                Navigator.pushNamed(context, '/userInfo');
              },
              child: Text("下一步"),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderImage extends StatefulWidget {
  final String imagePath;
  final String gender;
  final VoidCallback onSelect;
  final bool isSelected;

  GenderImage({
    required this.imagePath,
    required this.gender,
    required this.onSelect,
    required this.isSelected,
  });

  @override
  _GenderImageState createState() => _GenderImageState();
}

class _GenderImageState extends State<GenderImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: widget.isSelected ? 1 : 0.8 , end: widget.isSelected ? 1.2 : 1).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });

    // 初始化時就播放一次動畫
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GenderImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Column(
        children: [
          Transform.scale(
            scale: _animation.value,
            child: Image.asset(
              widget.imagePath,
              width: 120,
              height: 120,
            ),
          ),
          SizedBox(height: 10),
          Text(
            widget.gender,
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
