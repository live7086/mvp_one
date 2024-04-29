import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mvp_one/data/dummy_data.dart';
import 'package:mvp_one/models/meal.dart';
import 'package:mvp_one/provider/provider.dart';
import 'package:mvp_one/screens/allMainPages.dart';
import 'package:mvp_one/user/UserInformationPage.dart';
import 'package:mvp_one/widget_expense/expenses.dart';
import 'package:provider/provider.dart';
import 'action_selection_page.dart';
import 'pose_menu.dart';

class CustomizeMenuPage extends StatefulWidget {
  const CustomizeMenuPage({super.key, required this.uid});
  final String uid;
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<CustomizeMenuPage> {
  List<Meal> selectedMealsForCustomMenu = []; // 為自定義菜單選擇的餐點列表
  Map<Meal, int> mealCountsForCustomMenu = {}; // 自定義菜單中每個餐點的數量
  int _selectedPageIndex = 1;

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
    Provider.of<MenuTitleProvider>(context, listen: false).setMeals([]);
    Provider.of<MenuTitleProvider>(context, listen: false)
        .setSource(MenuSource.newMenu);

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
          title: const Text('編輯自定義菜單'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: title),
                decoration: const InputDecoration(labelText: '菜單標題'),
                onChanged: (value) {
                  newTitle = value;
                },
              ),
              TextField(
                controller: TextEditingController(text: description),
                decoration: const InputDecoration(labelText: '介紹文字'),
                onChanged: (value) {
                  newDescription = value;
                },
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    onTitleChanged(newTitle);
                    onDescriptionChanged(newDescription);
                    Provider.of<MenuTitleProvider>(context, listen: false)
                        .setMeals(meals);
                    Provider.of<MenuTitleProvider>(context, listen: false)
                        .setSource(MenuSource.editMenu);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActionSelectionPage(
                            selectedMealsForCustomMenu: meals),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        meals.clear();
                        meals.addAll(result['selectedMeals']);
                        mealCountsForCustomMenu = {
                          for (var meal in meals)
                            meal: mealCountsForCustomMenu[meal] ?? 1
                        };
                      });
                    }
                  },
                  child: const Text('編輯動作'),
                ),
                TextButton(
                  onPressed: () {
                    onTitleChanged(newTitle);
                    onDescriptionChanged(newDescription);
                    Navigator.of(context).pop();
                  },
                  child: const Text('確定'),
                ),
              ],
            ),
          ],
        );
      },
    );
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

  void _selectPage(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TabsScreen(
            uid: widget.uid,
          ),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CustomizeMenuPage(
            uid: widget.uid,
          ),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Expenses(
            uid: widget.uid,
          ),
        ));
        break;
      case 3:
        // 由于我们已经确保了 TabsScreen 接收了 uid，我们可以直接使用 widget.uid
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserInformationPage(uid: widget.uid),
        ));
        break;
      default:
        setState(() {
          _selectedPageIndex = index;
        });
        break;
    }
  }

  // 構建刪除自定義菜單的圖標
  Widget _buildDeleteCustomMenuIcon() {
    return IconButton(
      icon: const Icon(Icons.delete),
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
                title: const Text('刪除自定義菜單'),
                content: const Text('確定要刪除選中的自定義菜單嗎?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _isEditMode = false;
                      });
                    },
                    child: const Text('取消'),
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
                    child: const Text('確定'),
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
                  duration: const Duration(milliseconds: 300),
                  opacity: _isEditMode ? 1.0 : 0.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isEditMode = false;
                        for (var menu in customMenus) {
                          menu['isSelected'] = false;
                        }
                      });
                    },
                    // ignore: sort_child_properties_last
                    child: const Icon(Icons.cancel),
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
            child: const Text('新增'),
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
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              description,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isEditMode)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
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
                        ? const AlwaysStoppedAnimation(0.5)
                        : const AlwaysStoppedAnimation(0),
                    child: const Icon(Icons.expand_more, color: Colors.white),
                  ),
              ],
            ),
            // ignore: sort_child_properties_last
            children: _isEditMode
                ? []
                : [
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                          onPressed: () async {
                            final cameras = await availableCameras();
                            // 在開始運動前,將當前菜單的標題設置到 Provider 中
                            Provider.of<MenuTitleProvider>(context,
                                    listen: false)
                                .setMenuTitle(title);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuCameraScreen(
                                  cameras: cameras,
                                  selectedMeals: meals,
                                  mealCounts:
                                      mealCountsForCustomMenu.values.toList(),
                                ),
                              ),
                            );
                          },
                          child: const Text('開始運動'),
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
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: _isExpanded ? 220 : 120,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: widget.meal.imageUrl,
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
          style: const TextStyle(
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              '執行次數: ${widget.count}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
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
