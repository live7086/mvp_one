import 'package:flutter/material.dart';

class MemoryProvider extends StatefulWidget {
  const MemoryProvider({super.key, required this.uid, required this.child});

  final String uid;
  final Widget child;

  @override
  State<MemoryProvider> createState() => _MemoryProviderState();

  static _MemoryProviderState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedMemoryProvider>()!
        .data;
  }
}

class _MemoryProviderState extends State<MemoryProvider> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.uid);
  }

  Future<void> fetchUserData(String uid) async {
    // 在这里编写获取用户数据的逻辑，使用 uid 作为参数
    // 获取到的用户数据存储在 userData 中
    // 例如：userData = await getUserDataFromDatabase(uid);
    // 获取数据后调用 setState 更新界面
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedMemoryProvider(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedMemoryProvider extends InheritedWidget {
  const _InheritedMemoryProvider({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final _MemoryProviderState data;

  @override
  bool updateShouldNotify(_InheritedMemoryProvider old) => data != old.data;
}
