import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Gender { male, female, other }

String genderToString(Gender gender) {
  switch (gender) {
    case Gender.male:
      return '男性';
    case Gender.female:
      return '女性';
    case Gender.other:
      return '其他';
    default:
      return '未選擇';
  }
}

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key, required this.uid}) : super(key: key);

  final String uid;

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  DateTime? birthdate;
  Gender? _selectedGender = Gender.male;

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

  Widget _buildGenderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Gender.values.map((gender) {
        return Expanded(
          child: ListTile(
            title: Text(genderToString(gender)), // 使用上面定義的函數轉換
            leading: Radio<Gender>(
              value: gender,
              groupValue: _selectedGender,
              onChanged: (Gender? value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
          ),
        );
      }).toList(),
    );
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
      appBar: AppBar(title: const Text("個人資訊")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGenderRow(),
          TextField(
            controller: nicknameController,
            decoration: InputDecoration(
              labelText: '暱稱',
              errorText: isNicknameValid ? null : '請輸入暱稱',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '身高（公分）',
              errorText: isHeightValid ? null : '請輸入身高',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '體重（公斤）',
              errorText: isWeightValid ? null : '請輸入體重',
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              '出生日期',
              style: TextStyle(
                  color: isBirthdateValid ? Colors.black : Colors.red),
            ),
            subtitle: Text(
              birthdate == null
                  ? '請選擇出生日期'
                  : '${birthdate!.year}/${birthdate!.month}/${birthdate!.day}',
              style: TextStyle(
                  color: isBirthdateValid ? Colors.black : Colors.red),
            ),
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // 標記此處為 async
              validateFields();
              if (areAllFieldsFilled()) {
                Navigator.pushNamed(context, '/userLevel');

                final url = Uri.https(
                    'flutter-dogshit-default-rtdb.firebaseio.com',
                    'user-information.json');

                try {
                  final response = await http.post(
                    url,
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: json.encode({
                      'uid': widget.uid, // 将uid添加到数据库
                      'Gender': genderToString(_selectedGender!),
                      'nickname': nicknameController.text,
                      'height': heightController.text,
                      'weight': weightController.text,
                      'birthdate': birthdate?.toIso8601String(),
                    }),
                  );

                  if (response.statusCode == 200) {
                    // 成功處理
                  } else {
                    // 錯誤處理
                  }
                } catch (e) {
                  // 異常處理
                }
              }
            },
            child: const Text("下一步"),
          ),
        ],
      ),
    );
  }
}
