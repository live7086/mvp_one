import 'package:flutter/material.dart';

class startPage extends StatelessWidget {
  const startPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          const Positioned(
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
                  const ActionButton(),
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
  const BackgroundImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/start_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Text(
      "FLEㄨ",
      style: TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}

class YogaText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
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
  const ActionButton({Key? key}) : super(key: key);
  ButtonStyle createButtonStyle() {
    return ElevatedButton.styleFrom(
      onPrimary: Colors.black,
      primary: Colors.white,
      minimumSize: const Size(150, 50),
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
        Navigator.pushNamed(context, '/signin');
      },
      child: const Text(
        "開始使用",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
