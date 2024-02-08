import 'package:flutter/material.dart';
import 'package:mvp_one/utils/color_utils.dart';
import 'package:mvp_one/reusable_widgets/reusable_widget.dart';
import 'signup.dart';

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
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _emailTextController),
                SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                signInSignUpbutton(context, true, () {}),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
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
