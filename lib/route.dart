import 'package:flutter/material.dart';

// import 'genderSelectionPage.dart';
import 'actionPage.dart';
import 'cameraPage.dart';
import 'beginning/startPage.dart';
// import 'introPage.dart';
import 'user/userInfoPage.dart';
import 'user/userLevelPage.dart';
import 'beginning/setupDonePage.dart';
import 'User_menu.dart';
import 'search.dart';
import 'posePage.dart';
import 'model.dart';
import 'sign/signin.dart';
import 'sign/signup.dart';
import 'sign/home.dart';
import 'screens/tabs.dart';

class AppRoutes {
  static const String home = '/';
  static const String action = '/action';
  static const String intro = '/intro';
  static const String camera = '/camera';
  static const String gender = '/gender';
  static const String userInfo = '/userInfo';
  static const String userLevel = '/userLevel';
  static const String setupDone = '/setupDone';
  static const String search = '/search';
  static const String menu = '/User_menu';
  static const String posePage = '/posePage';
  static const String model = '/model';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String homee = '/homeScreen';
  static const String aboutme = '/aboutme';
  static const String tabscreen = '/tabscreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const startPage());
      case action:
        return MaterialPageRoute(builder: (_) => const ActionPage());
      // case intro:
      //   return MaterialPageRoute(builder: (_) => const IntroPage());
      case camera:
        return MaterialPageRoute(builder: (_) => const CameraPage());
      // case gender:
      //   return MaterialPageRoute(builder: (_) => const GenderSelectionPage());
      case userInfo:
        return MaterialPageRoute(
            builder: (_) => const UserInfoPage(
                  uid: '',
                ));
      case userLevel:
        return MaterialPageRoute(builder: (_) => const UserLevelPage());
      case setupDone:
        return MaterialPageRoute(builder: (_) => const SetupDonePage());
      case search:
        return MaterialPageRoute(builder: (_) => const Search());
      // case menu:
      //   return MaterialPageRoute(builder: (_) => const Usermenu());
      case posePage:
        return MaterialPageRoute(builder: (_) => HorizontalScrollListPage());
      case model:
        return MaterialPageRoute(builder: (_) => const model_1());
      case signin:
        return MaterialPageRoute(builder: (_) => const Signinsreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case homee:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case tabscreen:
        return MaterialPageRoute(
            builder: (_) => const TabsScreen(
                  uid: '',
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
