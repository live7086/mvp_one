import 'package:flutter/material.dart';
import 'package:mvp_one/sign/signin.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: _opacity,
      child: const Scaffold(
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
                      padding: EdgeInsets.only(bottom: 20),
                      child: YogaText(),
                    ),
                    ActionButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      "FLEX",
      style: TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}

class YogaText extends StatelessWidget {
  const YogaText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Get Flexy, Get Healthy",
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
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Signinsreen(),
        ));
        // Navigator.pushNamed(context, '/signin');
      },
      child: const Text(
        "開始使用",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
