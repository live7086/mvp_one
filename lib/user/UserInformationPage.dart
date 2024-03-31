import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.uid);
  }

  Future<void> fetchUserData(String uid) async {
    final query = FirebaseDatabase.instance
        .reference()
        .child('user-information')
        .orderByChild('uid')
        .equalTo(uid);

    try {
      // Retrieve the DatabaseEvent
      DatabaseEvent event = await query.once();

      // Check if the snapshot exists and contains any data
      if (event.snapshot.exists) {
        // Since we expect a single entry for each uid, let's extract the data.
        // Assuming 'user-information' node contains uid as keys directly
        Map<String, dynamic> data =
            Map<String, dynamic>.from(event.snapshot.value?[uid] ?? {});

        setState(() {
          userData = data;
          isLoading = false;
        });

        print('User Data: $userData');
      } else {
        setState(() {
          isLoading = false;
        });
        print('No user data available for uid: $uid');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred while fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Information')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text('No user data available.'))
              : ListView(
                  children: userData!.entries.map((entry) {
                    return ListTile(
                      title: Text('${entry.key}: ${entry.value.toString()}'),
                    );
                  }).toList(),
                ),
    );
  }
}
