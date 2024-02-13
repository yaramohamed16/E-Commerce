//Menna Nabil

import 'package:bloc/bloc.dart';

import '../../models/LoginModel/login.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../network/end_points.dart';
import '../../network/remote.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());


  LoginModel ? loginModel;

  void login({
    required String email,
    required String password,
}){
    emit(LoginLoadingState());
    DioHelper.postData(
        url: LOGIN,
        data: {
          'email':email,
          'password':password,
        }
        ).then((value) {
          print(value.data);
          loginModel = LoginModel.fromJson(value.data);
          emit(LoginSuccessState(loginModel!));
    }
    ).catchError((error){
      emit(LoginErrorState(error.toString()));
      print(error.toString());
    });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(LoginChangeVisibilityState());
  }
}
