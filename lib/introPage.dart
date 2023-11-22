import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() => runApp(IntroPage());

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("介紹頁面"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 點擊返回按鈕時，返回上一頁
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Image.asset("assets/action.png"),
                const SizedBox(height: 16.0),
                const Text(
                  "這是動作的文字介紹",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // 等待相機初始化完成
                    final initialized = await initializeCamera();
                    if (initialized) {
                      // 初始化完成，導航到相機頁面
                      Navigator.pushNamed(context, '/camera');
                    } else {
                      // 初始化未完成，顯示緩衝動畫或錯誤提示
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("相機初始化中"),
                          content: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                  child: const Text("前往相機頁面"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 初始化相機，返回是否初始化完成的狀態
  Future<bool> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final controller = CameraController(cameras[0], ResolutionPreset.max);
      await controller.initialize();
      return true; // 初始化完成
    } else {
      return false; // 沒有可用相機
    }
  }
}
