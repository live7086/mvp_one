import 'package:flutter/material.dart';

import 'GenderSelectionPage.dart';
import 'action_page.dart';
import 'camera_page.dart';
import 'startPage.dart';
import 'intro_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String action = '/action';
  static const String intro = '/intro';
  static const String camera = '/camera';
  static const String gender = '/gender';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:x 
        return MaterialPageRoute(builder: (_) => startPage());
      case action:
        return MaterialPageRoute(builder: (_) => ActionPage());
      case intro:
        return MaterialPageRoute(builder: (_) => IntroPage());
      case camera:
       return MaterialPageRoute(builder: (_) => CameraPage());
      case gender:
        return MaterialPageRoute(builder: (_) => GenderSelectionPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
