import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvp_one/customize_menu/cus_menu.dart';
import 'package:mvp_one/screens/tabs.dart';
import 'package:mvp_one/widget_expense/expenses.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  Map<String, dynamic>? userSpecificData;
  bool isLoading = true;
  File? _avatarImage;
  Offset _avatarPosition = Offset.zero;
  int _selectedPageIndex = 3;

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

  void _selectPage(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TabsScreen(
            uid: widget.uid,
          ),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomizeMenuPage(uid: widget.uid),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Expenses(
            uid: widget.uid,
          ),
        ));
        break;
      case 3:
        // 由于我们已经确保了 TabsScreen 接收了 uid，我们可以直接使用 widget.uid
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserInformationPage(uid: widget.uid),
        ));
        break;
      default:
        setState(() {
          _selectedPageIndex = index;
        });
        break;
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _nicknameController =
            TextEditingController(text: userSpecificData!['nickname'] ?? '');
        TextEditingController _genderController =
            TextEditingController(text: userSpecificData!['Gender'] ?? '');
        TextEditingController _birthdateController =
            TextEditingController(text: userSpecificData!['birthdate'] ?? '');
        TextEditingController _heightController =
            TextEditingController(text: userSpecificData!['height'] ?? '');
        TextEditingController _weightController =
            TextEditingController(text: userSpecificData!['weight'] ?? '');

        return AlertDialog(
          title: const Text('編輯個人資料'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: '暱稱',
                  ),
                ),
                TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: '性別',
                  ),
                ),
                TextFormField(
                  controller: _birthdateController,
                  decoration: const InputDecoration(
                    labelText: '生日',
                  ),
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: '身高 (cm)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: '體重 (kg)',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('保存'),
              onPressed: () async {
                // 在此處調用更新用戶數據的函數
                await _updateUserData(
                  _nicknameController.text,
                  _genderController.text,
                  _birthdateController.text,
                  _heightController.text,
                  _weightController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserData(String nickname, String gender, String birthdate,
      String height, String weight) async {
    final url = Uri.https(
      'flutter-dogshit-default-rtdb.firebaseio.com',
      '/user-information.json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        String? key;
        data.forEach((k, value) {
          if (value['uid'] == widget.uid) {
            key = k;
          }
        });

        if (key != null) {
          final updateUrl = Uri.https(
            'flutter-dogshit-default-rtdb.firebaseio.com',
            '/user-information/$key.json',
          );

          final updateData = {
            'nickname': nickname,
            'Gender': gender,
            'birthdate': birthdate,
            'height': height,
            'weight': weight,
          };

          final updateResponse = await http.patch(
            updateUrl,
            body: json.encode(updateData),
          );

          if (updateResponse.statusCode == 200) {
            print('用户数据更新成功');
            fetchUserData(widget.uid); // 重新获取用户数据
          } else {
            print('用户数据更新失败，状态码：${updateResponse.statusCode}');
          }
        } else {
          print('未找到对应UID的用户');
        }
      } else {
        print('请求失败，状态码：${response.statusCode}');
      }
    } catch (e) {
      print('请求异常：$e');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _avatarImage = File(pickedImage.path);
      });
    }
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
                          GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  _avatarPosition += details.delta;
                                });
                              },
                              child: Center(
                                child: GestureDetector(
                                  onTap: _pickImage, // 當點擊頭像時,觸發_pickImage函數
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage: _avatarImage != null
                                        ? FileImage(_avatarImage!)
                                        : null,
                                    child: _avatarImage == null
                                        ? const Icon(Icons.cameraswitch,
                                            size: 60)
                                        : null,
                                  ),
                                ),
                              )),
                          const SizedBox(height: 20),
                          Text(
                            '歡迎 ${userSpecificData!['nickname'] ?? '未設定'} ！',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
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
                                      userSpecificData!['birthdate'] != null
                                          ? '生日: ${userSpecificData!['birthdate'].split('T')[0]}'
                                          : '生日: 未設定',
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                        '身高: ${userSpecificData!['height'] ?? '未設定'}cm'),
                                  ),
                                  ListTile(
                                    title: Text(
                                        '體重: ${userSpecificData!['weight'] ?? '未設定'}kg'),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _showEditDialog,
                                    child: const Text('編輯資料'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 20, 50, 50),
                      child: ElevatedButton(
                        onPressed: _signOut,
                        child: const Text('登出'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(
                              255, 173, 99, 243), // Button text color
                          shape: const StadiumBorder(),
                          minimumSize: const Size(200, 50),
                        ),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: '動作菜單',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: '自訂菜單',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_add_outlined),
            label: '訓練紀錄',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
