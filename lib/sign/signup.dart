import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvp_one/reusable_widgets/reusable_widget.dart';
import 'package:mvp_one/utils/color_utils.dart';
import '../user/userInfoPage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('註冊失敗'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 200,
                ),
                reusableTextField("Enter Email", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Confirm Password", Icons.lock_outline, true,
                    _confirmPasswordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpbutton(context, false, () {
                  if (_passwordTextController.text !=
                      _confirmPasswordTextController.text) {
                    _showErrorDialog("密碼不一致");
                    return;
                  }

                  FirebaseAuth.instance
                      .fetchSignInMethodsForEmail(_emailTextController.text)
                      .then((signInMethods) {
                    if (signInMethods.isNotEmpty) {
                      _showErrorDialog("此電子郵件已經被註冊");
                    } else {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((userCredential) {
                        String uid = userCredential.user!.uid; // 獲取新用戶的 UID
                        print("Created New Account with UID: $uid");
                        // 將 UID 傳遞到基本資料表格頁面
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserInfoPage(uid: uid),
                          ),
                        );
                      }).onError((error, stackTrace) {
                        print("Error: ${error.toString()}");
                        _showErrorDialog("發生錯誤,請稍後再試");
                      });
                    }
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
