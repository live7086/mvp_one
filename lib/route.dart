import 'package:flutter/material.dart';

import 'genderSelectionPage.dart';
import 'actionPage.dart';
import 'cameraPage.dart';
import 'startPage.dart';
import 'introPage.dart';
import 'userInfoPage.dart';
import 'User_menu.dart';

class AppRoutes {
  static const String home = '/';
  static const String action = '/action';
  static const String intro = '/intro';
  static const String camera = '/camera';
  static const String gender = '/gender';
  static const String userInfo = '/userInfo';
  static const String usermeun = '/usermeun';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const startPage());
      case action:
        return MaterialPageRoute(builder: (_) => ActionPage());
      case intro:
        return MaterialPageRoute(builder: (_) => const IntroPage());
      case camera:
        return MaterialPageRoute(builder: (_) => CameraPage());
      case gender:
        return MaterialPageRoute(builder: (_) => const GenderSelectionPage());
      case userInfo:
        return MaterialPageRoute(builder: (_) => const UserInfoPage());
      case usermeun:
        return MaterialPageRoute(builder: (_) => const Usermeun());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
