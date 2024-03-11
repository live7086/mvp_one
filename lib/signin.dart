import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvp_one/aboutme.dart';
import 'package:mvp_one/utils/color_utils.dart';
import 'package:mvp_one/reusable_widgets/reusable_widget.dart';
import 'route.dart';

class Signinsreen extends StatefulWidget {
  const Signinsreen({super.key});

  @override
  State<Signinsreen> createState() => _SigninsreenState();
}

class _SigninsreenState extends State<Signinsreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
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
                SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(
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
                          builder: (context) => Aboutme(),
                        ),
                      );
                    }

                    Navigator.pushNamed(context, '/search'); // 成功登录后跳转
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
                        title: Text('登入失敗'),
                        content: Text(message),
                        actions: <Widget>[
                          TextButton(
                            child: Text('確定'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }),
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
