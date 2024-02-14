//Yara Mohamed

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/ShopCubit/cubit.dart';
import '../../cubit/ShopCubit/states.dart';
import '../../CacheHelper/cache_helper.dart';
import '../Login/login.dart';
import '../UpdateProfile/update_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';

  String userEmail = '';

  String userPhone = '';

  @override
  void initState() {
    super.initState();
    ShopCubit.get(context).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        // print('ProfilePage: Received state - $state');
        if (state is ShopSuccessUpdateUserState) {
          setState(() {
            userName = state.loginModel.data?.name ?? userName;
            userEmail = state.loginModel.data?.email ?? userEmail;
            userPhone = state.loginModel.data?.phone ?? userPhone;
          });
        }
      },
      builder: (context, state) {
        if (state is ShopLoadingUserDataState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                            ShopCubit.get(context).userModel?.data?.image ?? '',
                          ),
                        ),
                        const SizedBox(width: 25),
                        // Display user name and email here
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userEmail,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  buildTextButtonWithIcon(
                    'Update Profile',
                    Icons.arrow_forward,
                        () async {

                      Map<String, String> updatedData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdatePage(
                            initialUsername: userName,
                            initialEmail: userEmail,
                            initialPhone: userPhone,
                          ),
                        ),
                      );

                      setState(() {
                        userName = updatedData['username'] ?? userName;
                        userEmail = updatedData['email'] ?? userEmail;
                        userPhone = updatedData['phone'] ?? userPhone;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  buildTextButtonWithIcon(
                    'Log Out',
                    null,
                        () {
                      CacheHelper.removeData(key: 'token').then((value) {
                        if (value) {
                          // Clear the cached user data
                          ShopCubit.get(context).clearUserData();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextButtonWithIcon(
      String buttonText, IconData? iconData, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(
          const Size(double.infinity, 50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            buttonText,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 10),
          if (iconData != null) Icon(iconData)
        ],
      ),
    );
  }
}

