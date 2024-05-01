import 'package:flutter/material.dart';
import 'package:mvp_one/beginning/startPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'provider/provider.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 159, 120, 250));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuTitleProvider()),
        // 其他 Provider...
      ],
      child: MaterialApp(
        theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer,
            ),
          ),
          textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(
              color: kColorScheme.onSecondaryContainer,
              fontSize: 26,
            ),
          ),
        ),
        home: SplashScreen(),
      ),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: startPage(),
      duration: 3000,
      text: "FLEX",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 80.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
      colors: [
        Colors.grey[300]!,
        Colors.grey[400]!,
        Colors.grey[500]!,
        Colors.grey[600]!,
        Colors.grey[700]!,
      ],
      backgroundColor: Colors.black,
    );
  }
}