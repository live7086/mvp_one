import 'package:flutter/material.dart';

import 'action_page.dart';
import 'camera_page.dart';
import 'home_page.dart';
import 'intro_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String action = '/action';
  static const String intro = '/intro';
  static const String camera = '/camera';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case action:
        return MaterialPageRoute(builder: (_) => ActionPage());
      case intro:
        return MaterialPageRoute(builder: (_) => IntroPage());
      case camera:
       return MaterialPageRoute(builder: (_) => CameraPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
