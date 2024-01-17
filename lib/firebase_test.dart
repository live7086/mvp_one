import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'package:mvp_one/screens/home_screen.dart';

void main() async {
  // 添加後可訪問底層
  WidgetsFlutterBinding.ensureInitialized();
  // 使用 Firebase 預設選項初始化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const bool USE_EMULATOR = true;

  if (USE_EMULATOR) {
    String ip = 'localhost';
    await FirebaseStorage.instance.useStorageEmulator(ip, 9199);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}
