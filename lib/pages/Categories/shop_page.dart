//Fatma Metwally

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'category1_view.dart';
import 'category3_view.dart';

import 'category2_view.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  late TabController tabController;
  final dio = Dio();
  List<dynamic>? categories;
  Options options = Options(headers: {'lang': 'en'});
  void getCategories() async {
    Response response;
    response = await dio.get('https://student.valuxapps.com/api/categories',
        options: options);
    categories = response.data['data']['data'];
    setState(() {});
    print(categories.toString());
  }

  @override
  void initState() {
    getCategories();
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TabBar(
              labelPadding: const EdgeInsets.only(left: 3),
              indicatorColor: Colors.red,
              physics: const ScrollPhysics(),
              labelStyle:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              dividerHeight: 0.0,
              controller: tabController,
              labelColor: Colors.black,
              tabs: [
                Tab(
                  text: categories?[0]['name'] ?? '',
                ),
                Tab(
                  text: categories?[3]['name'] ?? '',
                ),
                Tab(
                  text: categories?[4]['name'] ?? '',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // Widgets for each tab
                  Category1View(id: categories?[0]['id'] ?? 44),
                  Category2View(id: categories?[3]['id']),
                  Category3View(id: categories?[4]['id']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
