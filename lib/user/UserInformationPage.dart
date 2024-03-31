import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  Map<String, dynamic>? userSpecificData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.uid);
  }

  Future<void> fetchUserData(String uid) async {
    final url = Uri.https(
      'flutter-dogshit-default-rtdb.firebaseio.com',
      '/user-information.json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        data.forEach((key, value) {
          if (value['uid'] == uid) {
            userSpecificData = value;
          }
        });

        if (userSpecificData != null) {
          print('找到用户: ${userSpecificData!['nickname']}');
        } else {
          print('未找到对应UID的用户');
        }
      } else {
        print('请求失败，状态码：${response.statusCode}');
      }
    } catch (e) {
      print('请求异常：$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // Navigate back to the login screen, or root of navigation stack
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('個人資料')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userSpecificData == null
              ? const Center(child: Text('沒有用戶數據。'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.person, size: 40),
                          ),
                          const SizedBox(height: 20),
                          Text('歡迎 ${userSpecificData!['nickname'] ?? '未設定'} ！',
                              style: Theme.of(context).textTheme.headline6,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        '性别: ${userSpecificData!['Gender'] ?? '未設定'}'),
                                  ),
                                  ListTile(
                                    title: Text(
                                        '生日: ${userSpecificData!['birthdate'] ?? '未設定'}'),
                                  ),
                                  ListTile(
                                    title: Text(
                                        '身高: ${userSpecificData!['height'] ?? '未設定'}cm'),
                                  ),
                                  ListTile(
                                    title: Text(
                                        '體重: ${userSpecificData!['weight'] ?? '未設定'}kg'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 20, 50, 200),
                      child: ElevatedButton(
                        onPressed: _signOut,
                        child: const Text('登出'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(
                              255, 173, 99, 243), // Button text color
                          shape:
                              StadiumBorder(), // Stadium shape for the button
                          minimumSize: Size(200,
                              50), // Button size, adjust the width to make it wider
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
