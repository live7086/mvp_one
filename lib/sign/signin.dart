import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvp_one/aboutme.dart';
import 'package:mvp_one/slidePageAnimation.dart';
import 'package:mvp_one/utils/color_utils.dart';
import 'package:mvp_one/reusable_widgets/reusable_widget.dart';
import 'package:mvp_one/widget_expense/expenses.dart';

import '../screens/tabs.dart';

class Signinsreen extends StatefulWidget {
  const Signinsreen({super.key});

  @override
  State<Signinsreen> createState() => _SigninsreenState();
}

class _SigninsreenState extends State<Signinsreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.08, 25, 0),
            child: Column(
              children: <Widget>[
                logoWidegt("assets/singinlogo.png"),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpbutton(context, true, () async {
                  try {
                    final UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailTextController.text.trim(),
                      password: _passwordTextController.text.trim(),
                    );
                    final User? user = userCredential.user;

                    if (user != null) {
                      print('登入成功，用戶UID是: ${user.uid}');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Aboutme(),
                        ),
                      );
                    }
                    Navigator.pushNamed(context, '/tabscreen'); // 成功登录后跳转
                  } on FirebaseAuthException catch (e) {
                    // 根据错误类型给出相应的用户反馈
                    String message;
                    switch (e.code) {
                      case 'user-not-found':
                        message = '用戶未找到';
                        break;
                      case 'wrong-password':
                        message = '密碼錯誤';
                        break;
                      default:
                        message = '登入錯誤，請重試';
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('登入失敗'),
                        content: Text(message),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('確定'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TabsScreen()), // 替换TheDestinationPage为你的目标页面
                    );
                  },
                  child: Text('跳過僅限測試'),
                ),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("還沒註冊嗎?", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: const Text(
            "Sign Up",
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
