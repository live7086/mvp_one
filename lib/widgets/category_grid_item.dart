import 'package:flutter/material.dart';
import 'package:mvp_one/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onSelectCategory,
  });

  final Category category;
  final void Function() onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectCategory,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              category.imageUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(5),
                color: Colors.black54,
                alignment: Alignment.center,
                child: Text(
                  category.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // child: Container(
            //   padding: const EdgeInsets.all(5),
            //   color: Colors.black54,
            //   alignment: Alignment.center,
            //   child: Text(
            //     category.title,
            //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //           color: Colors.white,
            //         ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
