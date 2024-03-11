import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Aboutme extends StatefulWidget {
  const Aboutme({super.key});

  @override
  _AboutmeState createState() => _AboutmeState();
}

class _AboutmeState extends State<Aboutme> {
  Map<String, dynamic>? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentUserUID();
  }

  void getCurrentUserUID() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserData(user.uid);
    } else {
      // 用户未登录或获取UID失败的处理逻辑
      // 例如：跳转到登录页面
    }
  }

  void fetchUserData(String uid) async {
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userData.exists) {
      setState(() {
        userInfo = userData.data();
        isLoading = false;
      });
    } else {
      // 处理用户数据不存在的情况
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户界面'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 设置按钮的功能
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  SizedBox(height: 10),
                  Text('欢迎的用户，欢迎回来！'),
                  SizedBox(height: 20),
                  userInfo != null
                      ? Card(
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('昵称'),
                                    Text(userInfo!['nickname'] ??
                                        '无数据'), // 假设Firestore中用户信息有nickname字段
                                  ],
                                ),
                                Divider(),
                                // 其他用户信息...
                              ],
                            ),
                          ),
                        )
                      : Text("用户信息加载失败"),
                ],
              ),
      ),
    );
  }
}
