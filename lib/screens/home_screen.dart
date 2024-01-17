import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../daos/firebase_storage_dao.dart';
import 'package:path/path.dart' show basename;

/// 首頁
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 初始化
  @override
  void initState() {
    super.initState();
  }

  // 繼承狀態關閉所執行
  @override
  void dispose() {
    super.dispose();
  }

  List<String>? fileList = [];
  String downLoadObjName = "";
  String deleteObjName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Firebase Storage"),
          centerTitle: true,
        ),
        body: ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
          // 上傳
          DefaultContainerWithCustomWidget(
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text("上傳"),
                )),
                Expanded(
                  child: TextButton(
                    child: Text("上傳物件"),
                    onPressed: () async {
                      // 叫出檔案選擇器
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      // 非電腦
                      if (result != null && !kIsWeb) {
                        // PlatformFile file = File(result.files.single.path);
                        File file = File(result.files.single.path!);
                        Uint8List FileBytes = await file.readAsBytes();
                        // 上傳值區
                        String fileName = basename(file.path);
                        print("檔名:$fileName");
                        await FirebaseStorageDao.uploadObject(
                            fileName, FileBytes);
                        // 電腦
                      } else if (result != null && kIsWeb) {
                        // PlatformFile file = File(result.files.single.path);
                        PlatformFile file = result.files.first;
                        Uint8List? FileBytes = file.bytes;
                        // 上傳值區
                        String fileName = basename(file.name);
                        print("檔名:$fileName");
                        await FirebaseStorageDao.uploadObject(
                            fileName, FileBytes!);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // 查閱
          DefaultContainerWithCustomWidget(
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 8),
              child: Text("查閱"),
            )),
            Expanded(
              child: TextButton(
                child: Text("檔案列表"),
                onPressed: () async {
                  List<String>? futureFileileList =
                      await FirebaseStorageDao.getAllFileNamesByStoragePath(
                          "/");
                  setState(() {
                    fileList = futureFileileList;
                  });
                },
              ),
            )
          ])),

          // 檔案列表
          DefaultContainerWithCustomWidget(Text(
            "檔案列表: $fileList",
            style: const TextStyle(overflow: TextOverflow.fade),
          )),

          // 刪除
          DefaultContainerWithCustomWidget(
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 8),
              child: TextFormField(
                onChanged: (inputValue) {
                  setState(() {
                    downLoadObjName = inputValue;
                  });
                },
              ),
            )),
            Expanded(
              child: TextButton(
                child: Text("刪除"),
                onPressed: () async {
                  await FirebaseStorageDao.deleteObject(downLoadObjName);
                },
              ),
            )
          ]))
        ]));
  }
}

// 預設方框，用來擺入 Widget 的
class DefaultContainerWithCustomWidget extends StatelessWidget {
  const DefaultContainerWithCustomWidget(this.customWidget, {Key? key})
      : super(key: key);
  final Widget customWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      height: 200,
      // 將 Container 設置成方框設置
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            // 陰影設置，看起來比較立體
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 6,
                blurRadius: 6,
                offset: Offset.fromDirection(5, -5))
          ]),
      child: customWidget,
    );
  }
}
