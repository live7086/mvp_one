import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  DateTime? birthdate;

  bool isNicknameValid = true;
  bool isHeightValid = true;
  bool isWeightValid = true;
  bool isBirthdateValid = true;

  bool areAllFieldsFilled() {
    return nicknameController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        birthdate != null;
  }

  void validateFields() {
    setState(() {
      isNicknameValid = nicknameController.text.isNotEmpty;
      isHeightValid = heightController.text.isNotEmpty;
      isWeightValid = weightController.text.isNotEmpty;
      isBirthdateValid = birthdate != null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Localizations.localeOf(context), // 使用當地語言
    );
    if (picked != null && picked != birthdate) {
      setState(() {
        birthdate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("個人資訊")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: nicknameController,
            decoration: InputDecoration(
              labelText: '暱稱',
              errorText: isNicknameValid ? null : '請輸入暱稱',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '身高（公分）',
              errorText: isHeightValid ? null : '請輸入身高',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '體重（公斤）',
              errorText: isWeightValid ? null : '請輸入體重',
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text(
              '出生日期',
              style: TextStyle(color: isBirthdateValid ? Colors.black : Colors.red),
            ),
            subtitle: Text(
              birthdate == null
                  ? '請選擇出生日期'
                  : '${birthdate!.year}/${birthdate!.month}/${birthdate!.day}',
              style: TextStyle(color: isBirthdateValid ? Colors.black : Colors.red),
            ),
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              validateFields();
              if (areAllFieldsFilled()) {
                // 在這裡處理按下按鈕後的動作
                // 可以使用 Navigator.push 跳轉到下一個頁面
              }
            },
            child: Text("下一步"),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserInfoPage(),
  ));
}
