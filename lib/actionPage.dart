import 'package:flutter/material.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({super.key});

  @override
  _ActionPageState createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  late bool isBorderVisible;

  @override
  void initState() {
    super.initState();
    isBorderVisible = true;
  }

  void _navigateToNextPage(BuildContext context) {
    // 导航到下一个页面
    Navigator.pushNamed(context, '/intro');
  }

  void _showCustomDialog(BuildContext context) {
    // Define the custom page transition animation
    PageRouteBuilder<dynamic> customPageRoute = PageRouteBuilder<dynamic>(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Stack(
          children: [
            // Background with semi-transparent color
            Container(
              color: Colors.black.withOpacity(0.7), // Adjust opacity as needed
            ),
            // Custom page content
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                color: Colors.white,
                child: const Center(
                  child: Text('快速預覽'),
                ),
              ),
            ),
          ],
        );
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        const begin = Offset(1.0, 0.0); // Start from the right
        const end = Offset.zero; // End position
        const curve = Curves.easeInOut; // Animation curve
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );

    // Navigate to the custom page
    Navigator.of(context).push(customPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("动作页面"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, isBorderVisible);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _navigateToNextPage(context);
              },
              onLongPress: () {
                _showCustomDialog(context);
              },
              onLongPressEnd: (details) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.of(context).pop('dismiss');
                });
              },
              child: Hero(
                tag: 'preview',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: isBorderVisible
                        ? Border.all(width: 2, color: Colors.black)
                        : null,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
