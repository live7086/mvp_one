import 'package:flutter/material.dart';

class HorizontalScrollListPage extends StatelessWidget {
  // 假設 dataFromDatabase 是從資料庫獲取的列表資料
  final List<String> dataFromDatabase = ['項目 A', '項目 B', '項目 C', '項目 D'];

  HorizontalScrollListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('橫向滑動列表'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          for (int i = 0; i < 6; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '所有動作',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: dataFromDatabase.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            dataFromDatabase[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
