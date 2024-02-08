import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../models/login.dart';
import '../../network/end_points.dart';
import '../../network/remote.dart';



part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  LoginModel ? loginModel;

  void register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }){
    emit(RegisterLoadingState());
    DioHelper.postData(
        url: Register,
        data: {
          'name':name,
          'phone':phone,
          'email':email,
          'password':password,
        }
    ).then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      emit(RegisterSuccessState(loginModel!));
    }
    ).catchError((error){
      emit(RegisterErrorState(error.toString()));
      print(error.toString());
    });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(RegisterChangeVisibilityState());
  }
}
