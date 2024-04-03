import 'package:flutter/material.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/screens/move.dart';
import 'package:mvp_one/screens/move_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ResultPage extends StatefulWidget {
  final int duration;
  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;

  ResultPage({
    required this.duration,
    required this.meal,
    required this.onToggleFavorite,
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int selectedIndex = -1;

  String formatDuration(int duration) {
    int minutes = duration ~/ 60;
    int seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void onIconTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // 設置背景顏色為淺灰色
      body: Column(
        children: [
          Expanded(
            flex: 2, // 增加圖片區塊的垂直空間
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.meal.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 100,
                  child: Text(
                    '恭喜您完成瑜珈練習!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Text(
                    widget.meal.title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 110,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                ),
                items: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 28,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '組數',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${widget.duration ~/ 60}',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 80,
                        color: Colors.grey[400],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 28,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '時間',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              formatDuration(widget.duration),
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '感覺如何?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '請選擇您對這次瑜珈練習的感受',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => onIconTapped(0),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.all(
                                    selectedIndex == 0 ? 16 : 12),
                                decoration: BoxDecoration(
                                  color: selectedIndex == 0
                                      ? Colors.blue[800]
                                      : Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.sentiment_dissatisfied,
                                  size: selectedIndex == 0 ? 40 : 32,
                                  color: selectedIndex == 0
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '太難',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: selectedIndex == 0
                                      ? Colors.blue[800]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onIconTapped(1),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.all(
                                    selectedIndex == 1 ? 16 : 12),
                                decoration: BoxDecoration(
                                  color: selectedIndex == 1
                                      ? Colors.yellow[600]
                                      : Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.sentiment_satisfied,
                                  size: selectedIndex == 1 ? 40 : 32,
                                  color: selectedIndex == 1
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '剛剛好',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: selectedIndex == 1
                                      ? Colors.yellow[600]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => onIconTapped(2),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.all(
                                    selectedIndex == 2 ? 16 : 12),
                                decoration: BoxDecoration(
                                  color: selectedIndex == 2
                                      ? Colors.green[600]
                                      : Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.sentiment_very_satisfied,
                                  size: selectedIndex == 2 ? 40 : 32,
                                  color: selectedIndex == 2
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '太簡單',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: selectedIndex == 2
                                      ? Colors.green[600]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealDetailsScreen(
                      meal: widget.meal,
                      onToggleFavorite: widget.onToggleFavorite,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                '返回動作列表',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
