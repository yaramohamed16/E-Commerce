//Menna Nabil
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'CacheHelper/cache_helper.dart';
import 'Constants/constant.dart';
import 'cubit/ShopCubit/cubit.dart';
import 'network/remote.dart';
import 'pages/HomePage/ShopLayout.dart';
import 'pages/Login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();

  String ? token = CacheHelper.getData(key: 'token') as String?;
  token ??= '';
  Widget widget;

  if (token.isNotEmpty) {
    widget = const ShopLayout();
  } else {
    widget = const LoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {

  final Widget startWidget;
  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..getHomeData()..getUserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
          useMaterial3: true,
        ),
        home: startWidget,
      ),
    );
  }
}