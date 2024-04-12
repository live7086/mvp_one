import 'package:flutter/material.dart';
import 'package:mvp_one/beginning/setupDonePage.dart';
import 'package:mvp_one/route.dart';

class UserLevelPage extends StatefulWidget {
  const UserLevelPage({Key? key}) : super(key: key);

  @override
  _UserLevelPage createState() => _UserLevelPage();
}

class _UserLevelPage extends State<UserLevelPage> {
  List<bool> isSelected = [false, false, false]; // 每個元素對應一個卡片的選擇狀態

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('難度選擇'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = [true, false, false];
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected[0]
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected[0]
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '從沒接觸過',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = [false, true, false];
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected[1]
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected[1]
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '初學者',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = [false, false, true];
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected[2]
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected[2]
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '中高階',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SetupDonePage()),
                  );
                  // 在這裡處理下一步的邏輯
                  // 例如，導航到下一個頁面
                },
                child: const Text('下一步'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
