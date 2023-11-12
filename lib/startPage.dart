import 'package:flutter/material.dart';

class startPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Positioned(
            left: 20,
            top: 65,
            child: Align(
              alignment: Alignment.topLeft,
              child: LogoText(),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 30,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: YogaText(),
                  ),
                  ActionButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/start_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LogoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "FLEX",
      style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}

class YogaText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Yoga Training Club",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        Text(
          "身心和諧，瑜珈共舞",
          style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  ButtonStyle createButtonStyle() {
    return ElevatedButton.styleFrom(
      onPrimary: Colors.black,
      primary: Colors.white,
      minimumSize: Size(150, 50),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: createButtonStyle(),
      onPressed: () {
        Navigator.pushNamed(context, '/gender');
      },
      child: Text(
        "開始使用",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
