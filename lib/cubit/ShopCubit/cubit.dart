
import '../models/favorites_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cache_helper.dart';
import '../models/login.dart';
import '../pages/Profile.dart';
import '../pages/shop_page.dart';
import 'states.dart';
import '../models/change_favorites_model.dart';
import '../models/home_model.dart';
import '../network/end_points.dart';
import '../network/remote.dart';
import '../pages/favorites.dart';
import '../pages/products.dart';


class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const ShopPage(),
     FavoritesScreen(),
    const ProfilePage(),
  ];

void changeBottom(int index)
{
  currentIndex = index;
  if (index == 3) getUserData();
  emit(ShopChangeBottomNavState());
}
  HomeModel? homeModel;
Map<int,bool> favorites={};


  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url:HOME,
      token:token,
    ).then((value)
    {
      homeModel = HomeModel.fromJson(value.data);

      for(ProductModel product in homeModel?.data
      .products??[]) {
        favorites.addAll({
          product.id:product.inFavorites,
             });
      }
      emit(ShopSuccessHomeDataState());
    }).catchError((error)
    {
      emit(ShopErrorHomeDataState());
    });

  }

   ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId){
    favorites[productId]= !favorites[productId]!;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
        url:FAVORITES,
        data:{
          'product_id':productId,
        },
        token: token,

    )
        .then((value){
      changeFavoritesModel=ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if(!changeFavoritesModel!.status){ //if false light off
        favorites[productId]= !favorites[productId]!;
      }else{
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    })
        .catchError((error){
      favorites[productId]= !favorites[productId]!;
          emit(ShopErrorChangeFavoritesState());
    });

  }
  FavoritesModel? favoritesModel;
  void getFavorites(){
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
        url: FAVORITES,
      token: token
    ).then((value){
      favoritesModel=FavoritesModel.fromJson(value.data);
      print(value.data.toString());

      emit(ShopSuccessGetFavoritesState(favoritesModel!));
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  //getUserData:

  LoginModel? userModel;

  void getUserData() async {
    emit(ShopLoadingUserDataState());
    // print("Token: $token");

    try {
      final value = await DioHelper.getData(
        url: PROFILE,
        token: token,
      );
      userModel = LoginModel.fromJson(value.data);

      if (userModel?.data != null) {
        // print("User data: ${userModel?.data?.name}, ${userModel?.data?.email}");
        emit(ShopSuccessUpdateUserState(userModel!));

      } else {
        print("User data is null");
        emit(ShopErrorUserDataState());
      }
    } catch (error) {
      print("Error fetching user data: $error");
      emit(ShopErrorUserDataState());
    }
  }

  void clearUserData() {
    userModel = null;
  }

  //UpdateUserData:

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) async {
    emit(ShopLoadingUpdateUserState());
    print("Token: $token");

    try {
      final value = await DioHelper.putData(
        url: UPDATEPROFILE,
        token: token,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
        },
      );
      // print("Updated user data response: $value");

      userModel = LoginModel.fromJson(value.data);

      if (userModel?.data != null) {
        // print("User data: ${userModel?.data?.name}, ${userModel?.data?.email}");
        emit(ShopSuccessUpdateUserState(userModel!));
      } else {
        print("User data is null");
        emit(ShopErrorUpdateUserState());
      }
    } catch (error) {
      print("Error updating user data: $error");
      emit(ShopErrorUpdateUserState());
    }
  }

}
String token = CacheHelper.getData(key: 'token');


//
// void printFullText(String text){
//   final pattern = RegExp('.{1,800}');
//   pattern.allMatches(text).forEach((match) => print(match.group(0)));
// }


