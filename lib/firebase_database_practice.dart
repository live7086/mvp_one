import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("user/123");

  Future<void> updateData() async {
    // Only update the name, leave the age and address!
    await ref.update({
      "age": 19,
    });
  }

  void f() async {
    await ref.set({
      "name": "John",
      "age": 18,
      "address": {
        "line1": "100 Mountain View",
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Data Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            updateData();
            //f();
          },
          child: Text('Update Data'),
        ),
      ),
    );
  }
}
