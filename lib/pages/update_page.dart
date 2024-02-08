//update
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'text_input_field.dart';

class UpdatePage extends StatefulWidget {
  final String initialUsername;
  final String initialEmail;
  final String initialPhone;
  const UpdatePage(
      {Key? key,
      required this.initialUsername,
      required this.initialEmail,
      required this.initialPhone})
      : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Update Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConditionalBuilder(
              condition: state is! ShopLoadingUpdateUserState,
              builder: (context) => buildForm(),
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }

  Widget buildForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Update your profile information:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextInputField(
            labelText: 'Username',
            controller: _usernameController,
          ),
          const SizedBox(height: 10),
          TextInputField(
            labelText: 'Email',
            controller: _emailController,
          ),
          const SizedBox(height: 20),
          TextInputField(
            labelText: 'Phone',
            controller: _phoneController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                String updatedUsername = _usernameController.text;
                String updatedEmail = _emailController.text;
                String updatedPhone = _phoneController.text;

                ShopCubit.get(context).updateUserData(
                  name: updatedUsername,
                  email: updatedEmail,
                  phone: updatedPhone,
                );

                Navigator.pop(context,
                    {'username': updatedUsername, 'email': updatedEmail});
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
