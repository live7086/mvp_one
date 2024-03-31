import 'package:flutter/material.dart';
import 'package:mvp_one/data/dummy_data.dart';
import 'package:mvp_one/models/meal.dart';
import 'action_selection_page.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<Meal> selectedMeals = []; // 已選擇的動作列表
  Map<Meal, int> mealCounts = {}; // 每個動作的執行次數

  // 預設菜單1
  List<Meal> defaultMenu1 =
      dummyMeals.where((meal) => meal.categories.contains('c1')).toList();

  // 預設菜單2
  List<Meal> defaultMenu2 =
      dummyMeals.where((meal) => meal.categories.contains('c2')).toList();

  String defaultMenu1Name = '預設菜單1'; // 預設菜單1的名稱
  String defaultMenu2Name = '預設菜單2'; // 預設菜單2的名稱
  String defaultMenu1Description = '這是預設菜單1的介紹文字'; // 預設菜單1的介紹文字
  String defaultMenu2Description = '這是預設菜單2的介紹文字'; // 預設菜單2的介紹文字

  bool isDefaultMenu1Expanded = false; // 預設菜單1是否展開
  bool isDefaultMenu2Expanded = false; // 預設菜單2是否展開

  List<Map<String, dynamic>> customMenus = []; // 自定義菜單列表

  // 打開動作選擇頁面
  void _openActionSelectionPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionSelectionPage(selectedMeals: selectedMeals),
      ),
    );

    if (result != null) {
      setState(() {
        selectedMeals = result['selectedMeals'];
        mealCounts = {
          for (var meal in selectedMeals) meal: mealCounts[meal] ?? 1
        };

        // 添加新的自定義菜單
        customMenus.add({
          'title': result['menuTitle'],
          'description': result['menuDescription'],
          'meals': selectedMeals,
          'isExpanded': false,
        });
      });
    }
  }

  // 重新排序動作
  void _reorderMeals(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Meal item = selectedMeals.removeAt(oldIndex);
    selectedMeals.insert(newIndex, item);
  }

  // 更新動作的執行次數
  void _updateMealCount(Meal meal, String countString) {
    if (countString.isEmpty) {
      setState(() {
        mealCounts[meal] = 1;
      });
    } else {
      try {
        final count = int.parse(countString);
        if (count != mealCounts[meal]) {
          setState(() {
            mealCounts[meal] = count;
          });
        }
      } catch (e) {
        setState(() {
          mealCounts[meal] = 1;
        });
      }
    }
  }

  // 選擇預設菜單
  void _selectDefaultMenu(List<Meal> defaultMenu) {
    setState(() {
      selectedMeals = defaultMenu;
      mealCounts = {
        for (var meal in selectedMeals) meal: mealCounts[meal] ?? 1
      };
    });
  }

  // 顯示編輯菜單的彈出窗口
  void _showEditMenuDialog(
    String title,
    String description,
    List<Meal> meals,
    ValueChanged<String> onTitleChanged,
    ValueChanged<String> onDescriptionChanged,
  ) {
    String newTitle = title;
    String newDescription = description;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('編輯菜單'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: title),
                decoration: InputDecoration(labelText: '菜單標題'),
                onChanged: (value) {
                  newTitle = value;
                },
              ),
              TextField(
                controller: TextEditingController(text: description),
                decoration: InputDecoration(labelText: '介紹文字'),
                onChanged: (value) {
                  newDescription = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                onTitleChanged(newTitle);
                onDescriptionChanged(newDescription);
                Navigator.of(context).pop();
              },
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('起始頁面'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 預設菜單1
            _buildMenu(
              defaultMenu1Name,
              defaultMenu1Description,
              defaultMenu1,
              isDefaultMenu1Expanded,
              (value) => setState(() => defaultMenu1Name = value),
              (value) => setState(() => defaultMenu1Description = value),
              (value) => setState(() => isDefaultMenu1Expanded = value),
            ),
            // 預設菜單2
            _buildMenu(
              defaultMenu2Name,
              defaultMenu2Description,
              defaultMenu2,
              isDefaultMenu2Expanded,
              (value) => setState(() => defaultMenu2Name = value),
              (value) => setState(() => defaultMenu2Description = value),
              (value) => setState(() => isDefaultMenu2Expanded = value),
            ),
            // 自定義菜單列表
            ...customMenus.map((menu) {
              return _buildMenu(
                menu['title'],
                menu['description'],
                menu['meals'],
                menu['isExpanded'],
                (value) {
                  setState(() {
                    menu['title'] = value;
                  });
                },
                (value) {
                  setState(() {
                    menu['description'] = value;
                  });
                },
                (value) {
                  setState(() {
                    menu['isExpanded'] = value;
                  });
                },
              );
            }).toList(),
            // 已選擇的動作列表
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: selectedMeals.length,
              itemBuilder: (context, index) {
                final meal = selectedMeals[index];
                return _MealItem(
                  key: Key(meal.id),
                  meal: meal,
                  count: mealCounts[meal] ?? 1,
                  onCountChanged: (count) => _updateMealCount(meal, count),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openActionSelectionPage,
        child: Text('新增'),
      ),
    );
  }

  // 構建菜單
  Widget _buildMenu(
    String title,
    String description,
    List<Meal> meals,
    bool isExpanded,
    ValueChanged<String> onTitleChanged,
    ValueChanged<String> onDescriptionChanged,
    ValueChanged<bool> onExpansionChanged,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          unselectedWidgetColor: Colors.white,
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            description,
            style: TextStyle(color: Colors.white),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  _showEditMenuDialog(
                    title,
                    description,
                    meals,
                    onTitleChanged,
                    onDescriptionChanged,
                  );
                },
              ),
              RotationTransition(
                turns: isExpanded
                    ? AlwaysStoppedAnimation(0.5)
                    : AlwaysStoppedAnimation(0),
                child: Icon(Icons.expand_more, color: Colors.white),
              ),
            ],
          ),
          children: meals.map((meal) {
            return ListTile(
              title: Text(
                meal.title,
                style: TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onExpansionChanged: onExpansionChanged,
          initiallyExpanded: isExpanded,
        ),
      ),
    );
  }
}

class _MealItem extends StatefulWidget {
  final Meal meal;
  final int count;
  final ValueChanged<String> onCountChanged;

  const _MealItem({
    Key? key,
    required this.meal,
    required this.count,
    required this.onCountChanged,
  }) : super(key: key);

  @override
  _MealItemState createState() => _MealItemState();
}

class _MealItemState extends State<_MealItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isExpanded ? 200 : 100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(widget.meal.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: _isExpanded
                ? _buildExpandedContent()
                : _buildCollapsedContent(),
          ),
        ),
      ),
    );
  }

  // 構建收起狀態下的內容
  Widget _buildCollapsedContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: ListTile(
        title: Text(
          widget.meal.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 構建展開狀態下的內容
  Widget _buildExpandedContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: ListTile(
        title: Text(
          widget.meal.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '執行次數: ${widget.count}',
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '執行次數',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onChanged: widget.onCountChanged,
            ),
          ],
        ),
      ),
    );
  }
}
