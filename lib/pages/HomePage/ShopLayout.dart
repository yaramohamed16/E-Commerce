//Rana Mohsen


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/ShopCubit/cubit.dart';
import '../../cubit/ShopCubit/states.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..getHomeData()..getFavorites()..getUserData(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          List<String> appBarTitles=['Market','Categories','Favorites','Profile'];
          return Scaffold(
            appBar: AppBar(
              title:Text(appBarTitles[cubit.currentIndex]),

            ),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (index){
                cubit.changeBottom(index);
              },
              currentIndex: cubit.currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,),
                  label: 'Home', backgroundColor: Colors.red,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.category_rounded,
                    size: 30,),
                  label: 'Category',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_border,
                    size: 30,),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    size: 30,),
                  label: 'Settings',
                ),
              ],),


          );
        },
      ),
    );
  }
}
