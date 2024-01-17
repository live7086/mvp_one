// 僅用於筆者學習，讀者可自行取用更改
// 參考文件：
// https://firebase.google.com/docs/storage/flutter/upload-files
// https://github.com/firebase/flutterfire/blob/master/packages/firebase_storage/firebase_storage/example/lib/main.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

/// 與 Firebase Storage 值區溝通的橋樑
class FirebaseStorageDao {
  /// 傳入在 Storage 的指定路徑，並回傳在該路徑資料夾下的所有檔案名稱
  static Future<List<String>?> getAllFileNamesByStoragePath(
      String directoryPath) async {
    List<String> fileNames = [];

    // 建立 reference 索引
    final storageRef = FirebaseStorage.instance.ref();
    // 指定 reference 為哪個目錄
    final folderRef = storageRef.child(directoryPath);
    // 列出所有檔案
    final listResult = await folderRef.listAll();
    // 將各個檔案名稱一一取出，並放入清單
    print("列出在值區中的 $directoryPath 路徑下所有檔案名稱：");
    for (var item in listResult.items) {
      print(item.name);
      fileNames.add(item.name);
    }
    return fileNames;
  }

  /// 上傳檔案(以位元的形式)到指定的值區路徑
  static Future<void> uploadObject(String goalPath, Uint8List file) async {
    // 建立 reference 索引
    final storageRef = FirebaseStorage.instance.ref();

    // 指定目標 reference
    final fileGoalRef = storageRef.child(goalPath);

    try {
      // 上傳檔案
      await fileGoalRef.putData(file);
    } on FirebaseException catch (e) {
      // 若出錯，報出來
      print("Failed with error '${e.code}': ${e.message}");
    }
  }

  // 刪除在值區的指定路徑物件
  static Future<void> deleteObject(String goalPath) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference to the file to delete
    final desertRef = storageRef.child(goalPath);
    // Delete the file
    await desertRef.delete();
  }
}
