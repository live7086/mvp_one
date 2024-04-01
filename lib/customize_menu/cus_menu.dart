import 'package:flutter/material.dart';
import 'package:mvp_one/data/dummy_data.dart';
import 'package:mvp_one/models/meal.dart';
import 'action_selection_page.dart';

class CustomizeMenuPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<CustomizeMenuPage> {
  List<Meal> selectedMealsForCustomMenu = []; // 為自定義菜單選擇的餐點列表
  Map<Meal, int> mealCountsForCustomMenu = {}; // 自定義菜單中每個餐點的數量

  List<Map<String, dynamic>> customMenus = [
    // 自定義菜單列表
    {
      'title': '預設菜單1',
      'description': '這是預設菜單1的介紹文字',
      'meals':
          dummyMeals.where((meal) => meal.categories.contains('c1')).toList(),
      'isExpanded': false,
      'isSelected': false,
    },
    {
      'title': '預設菜單2',
      'description': '這是預設菜單2的介紹文字',
      'meals':
          dummyMeals.where((meal) => meal.categories.contains('c2')).toList(),
      'isExpanded': false,
      'isSelected': false,
    },
  ];

  bool _isEditMode = false; // 是否處於編輯模式

  // 打開動作選擇頁面
  void _openActionSelectionPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionSelectionPage(
            selectedMealsForCustomMenu: selectedMealsForCustomMenu),
      ),
    );

    if (result != null) {
      setState(() {
        selectedMealsForCustomMenu = result['selectedMeals'];
        mealCountsForCustomMenu = {
          for (var meal in selectedMealsForCustomMenu)
            meal: mealCountsForCustomMenu[meal] ?? 1
        };

        customMenus.add({
          'title': result['menuTitle'],
          'description': result['menuDescription'],
          'meals': selectedMealsForCustomMenu,
          'isExpanded': false,
          'isSelected': false,
        });
      });
    }
  }

  // 更新自定義菜單中餐點的數量
  void _updateMealCountForCustomMenu(Meal meal, String countString) {
    if (countString.isEmpty) {
      setState(() {
        mealCountsForCustomMenu[meal] = 1;
      });
    } else {
      try {
        final count = int.parse(countString);
        if (count != mealCountsForCustomMenu[meal]) {
          setState(() {
            mealCountsForCustomMenu[meal] = count;
          });
        }
      } catch (e) {
        setState(() {
          mealCountsForCustomMenu[meal] = 1;
        });
      }
    }
  }

  // 顯示編輯自定義菜單的對話框
  void _showEditCustomMenuDialog(
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
          title: Text('編輯自定義菜單'),
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

  // 構建刪除自定義菜單的圖標
  Widget _buildDeleteCustomMenuIcon() {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity!.abs() > 100) {
                  Navigator.of(context).pop();
                  setState(() {
                    _isEditMode = false;
                  });
                }
              },
              child: AlertDialog(
                title: Text('刪除自定義菜單'),
                content: Text('確定要刪除選中的自定義菜單嗎?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _isEditMode = false;
                      });
                    },
                    child: Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        customMenus
                            .removeWhere((menu) => menu['isSelected'] == true);
                        _isEditMode = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('確定'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('起始頁面'),
        actions: [
          if (_isEditMode) _buildDeleteCustomMenuIcon(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: customMenus.map((menu) {
                return _buildCustomMenu(
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
                  isSelected: menu['isSelected'],
                  onSelectChanged: (value) {
                    setState(() {
                      menu['isSelected'] = value ?? false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          if (_isEditMode)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 28),
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: _isEditMode ? 1.0 : 0.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isEditMode = false;
                        customMenus.forEach((menu) {
                          menu['isSelected'] = false;
                        });
                      });
                    },
                    child: Icon(Icons.cancel),
                    backgroundColor: Colors.red,
                    heroTag: 'cancelButton',
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 16),
          child: FloatingActionButton(
            onPressed: _openActionSelectionPage,
            child: Text('新增'),
          ),
        ),
      ),
    );
  }

  // 構建自定義菜單
  Widget _buildCustomMenu(
    String title,
    String description,
    List<Meal> meals,
    bool isExpanded,
    ValueChanged<String> onTitleChanged,
    ValueChanged<String> onDescriptionChanged,
    ValueChanged<bool> onExpansionChanged, {
    bool isSelected = false,
    ValueChanged<bool?>? onSelectChanged,
  }) {
    return GestureDetector(
      onTap: _isEditMode
          ? () {
              onSelectChanged?.call(!isSelected);
            }
          : null,
      onLongPress: !isExpanded
          ? () {
              setState(() {
                _isEditMode = true;
              });
            }
          : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.purple.shade800],
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
            leading: _isEditMode
                ? Checkbox(
                    value: isSelected,
                    onChanged: onSelectChanged,
                  )
                : null,
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
                if (!_isEditMode)
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _showEditCustomMenuDialog(
                        title,
                        description,
                        meals,
                        onTitleChanged,
                        onDescriptionChanged,
                      );
                    },
                  ),
                if (!_isEditMode)
                  RotationTransition(
                    turns: isExpanded
                        ? AlwaysStoppedAnimation(0.5)
                        : AlwaysStoppedAnimation(0),
                    child: Icon(Icons.expand_more, color: Colors.white),
                  ),
              ],
            ),
            children: _isEditMode
                ? []
                : [
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: meals.map((meal) {
                        return _CustomMenuMealItem(
                          key: Key(meal.id),
                          meal: meal,
                          count: mealCountsForCustomMenu[meal] ?? 1,
                          onCountChanged: (count) =>
                              _updateMealCountForCustomMenu(meal, count),
                          onDismissed: (direction) {
                            setState(() {
                              meals.remove(meal);
                              mealCountsForCustomMenu.remove(meal);
                            });
                          },
                        );
                      }).toList(),
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Meal item = meals.removeAt(oldIndex);
                          meals.insert(newIndex, item);
                        });
                      },
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: 導航到運動頁面
                          },
                          child: Text('開始運動'),
                        ),
                      ),
                  ],
            onExpansionChanged: _isEditMode
                ? null
                : (bool? expanded) {
                    onExpansionChanged(expanded ?? false);
                  },
            initiallyExpanded: isExpanded,
          ),
        ),
      ),
    );
  }
}

// 自定義菜單中的餐點項目
class _CustomMenuMealItem extends StatefulWidget {
  final Meal meal;
  final int count;
  final ValueChanged<String> onCountChanged;
  final DismissDirectionCallback onDismissed;

  const _CustomMenuMealItem({
    Key? key,
    required this.meal,
    required this.count,
    required this.onCountChanged,
    required this.onDismissed,
  }) : super(key: key);

  @override
  _CustomMenuMealItemState createState() => _CustomMenuMealItemState();
}

class _CustomMenuMealItemState extends State<_CustomMenuMealItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.meal.id),
      direction: DismissDirection.endToStart,
      onDismissed: widget.onDismissed,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isExpanded ? 220 : 120,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(widget.meal.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child:
              _isExpanded ? _buildExpandedContent() : _buildCollapsedContent(),
        ),
      ),
    );
  }

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
            SizedBox(height: 8),
            Text(
              '執行次數: ${widget.count}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 8),
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
