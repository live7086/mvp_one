import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Aboutme extends StatefulWidget {
  const Aboutme({Key? key}) : super(key: key);

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
      print("用户未登录");
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
      print("用户数据不存在");
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
            ? const CircularProgressIndicator()
            : userInfo != null
                ? ListView(
                    children: [
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '昵称: ${userInfo!['nickname'] ?? '未设置'}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '邮箱: ${userInfo!['email'] ?? '未设置'}',
                        style: TextStyle(fontSize: 20),
                      ),
                      // 根据需要添加更多信息
                    ],
                  )
                : const Text("用户信息加载失败"),
      ),
    );
  }
}
