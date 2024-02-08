import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
                signInSignUpbutton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.pushNamed(context, '/userInfo');
                  });
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
