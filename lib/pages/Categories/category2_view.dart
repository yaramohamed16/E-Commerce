import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'catigory_card.dart';

class Category2View extends StatefulWidget {
  const Category2View({Key? key, this.id}) : super(key: key);
  final int? id;
  @override
  State<Category2View> createState() => _Category2ViewState();
}

class _Category2ViewState extends State<Category2View> {
  final Dio dio = Dio();
  Options options = Options(headers: {'lang': 'en'});
  List<CategoryItemModel>? category = [];
  bool isLoading = true;

  void getCategoryDetails() async {
    try {
      Response response = await dio.get(
          'https://student.valuxapps.com/api/categories/${widget.id}',
          options: options);
      List<dynamic> data = response.data['data']['data'];

      // استخدم forEach لتحويل البيانات إلى قائمة category
      data.forEach((item) {
        category
            ?.add(CategoryItemModel(name: item['name'], image: item['image']));
      });

      setState(() {
        isLoading = false; // Set loading to false once data is fetched
      });
      print(category.toString());
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false in case of an error
      });
      print('Error fetching category details: $e');
    }
  }

  @override
  void initState() {
    getCategoryDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red[700],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Summer sales".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "Up to 50% off".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        CategoryCard(categoryItemModel: category![index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: category!.length,
                  ),
                ),
              ],
            ),
          );
  }
}
