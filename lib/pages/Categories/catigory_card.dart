//Fatma Metwally

import 'package:flutter/material.dart';

class CategoryItemModel {
  final String name;
  final String image;

  CategoryItemModel({required this.name, required this.image});
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.categoryItemModel})
      : super(key: key);

  final CategoryItemModel categoryItemModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
      height: 120, // Adjust the height as needed
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: Text(
                categoryItemModel.name ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ),
           const SizedBox(width: 30),
            Expanded(
              child: Image.network(
                categoryItemModel.image ?? '',
                fit: BoxFit.contain,
                height: 110,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
