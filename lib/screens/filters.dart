import 'package:flutter/material.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
  level1,
  level2,
  level3,
  time1,
  time2,
}

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.currentFilters});

  final Map<Filter, bool> currentFilters;

  @override
  State<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFreeFilter = false;
  var _lactoseFreeFilter = false;
  var _vegetarianFilter = false;
  var _veganFilter = false;
  var _level1Filter = false;
  var _level2Filter = false;
  var _level3Filter = false;
  var _time1Filter = false;
  var _time2Filter = false;

  @override
  void initState() {
    super.initState();
    _glutenFreeFilter = widget.currentFilters[Filter.glutenFree] ?? false;
    _lactoseFreeFilter = widget.currentFilters[Filter.lactoseFree] ?? false;
    _vegetarianFilter = widget.currentFilters[Filter.vegetarian] ?? false;
    _veganFilter = widget.currentFilters[Filter.vegan] ?? false;
    _level1Filter = widget.currentFilters[Filter.level1] ?? false;
    _level2Filter = widget.currentFilters[Filter.level2] ?? false;
    _level3Filter = widget.currentFilters[Filter.level3] ?? false;
    _time1Filter = widget.currentFilters[Filter.time1] ?? false;
    _time2Filter = widget.currentFilters[Filter.time2] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Filters'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop({
            Filter.glutenFree: _glutenFreeFilter,
            Filter.lactoseFree: _lactoseFreeFilter,
            Filter.vegetarian: _vegetarianFilter,
            Filter.vegan: _veganFilter,
            Filter.level1: _level1Filter,
            Filter.level2: _level2Filter,
            Filter.level3: _level3Filter,
            Filter.time1: _time1Filter,
            Filter.time2: _time2Filter,
          });
          return false;
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 運動部位
            Text(
              '運動部位',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              value: _glutenFreeFilter,
              onChanged: (isChecked) {
                setState(() {
                  _glutenFreeFilter = isChecked;
                });
              },
              title: Text(
                '腿部',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '只包含腿部動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
            SwitchListTile(
              value: _lactoseFreeFilter,
              onChanged: (isChecked) {
                setState(() {
                  _lactoseFreeFilter = isChecked;
                });
              },
              title: Text(
                '平衡',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '只包含平衡動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
            SwitchListTile(
              value: _vegetarianFilter,
              onChanged: (isChecked) {
                setState(() {
                  _vegetarianFilter = isChecked;
                });
              },
              title: Text(
                '核心',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '只包含核心動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
            SwitchListTile(
              value: _veganFilter,
              onChanged: (isChecked) {
                setState(() {
                  _veganFilter = isChecked;
                });
              },
              title: Text(
                '四肢',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '只包含四肢動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
            // 難度級別
            Text(
              '難度級別',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              value: _level1Filter,
              onChanged: (isChecked) {
                setState(() {
                  _level1Filter = isChecked;
                });
              },
              title: Text(
                '初級',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '適合初學者的動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
            SwitchListTile(
              value: _level2Filter,
              onChanged: (isChecked) {
                setState(() {
                  _level2Filter = isChecked;
                });
              },
              title: Text(
                '中級',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '適合入門者的動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
            SwitchListTile(
              value: _level3Filter,
              onChanged: (isChecked) {
                setState(() {
                  _level3Filter = isChecked;
                });
              },
              title: Text(
                '高級',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '適合高手的動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
            // 運動時間
            Text(
              '運動時間',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              value: _time1Filter,
              onChanged: (isChecked) {
                setState(() {
                  _time1Filter = isChecked;
                });
              },
              title: Text(
                '10分鐘內',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '短時間快速的動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
            SwitchListTile(
              value: _time2Filter,
              onChanged: (isChecked) {
                setState(() {
                  _time2Filter = isChecked;
                });
              },
              title: Text(
                '10分鐘以上',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                '耐力訓練動作',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 24),
            ),
          ],
        ),
      ),
    );
  }
}
