// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/auth/view/screen/login_screen.dart';
import 'package:social_media_app/home_screen.dart';
import 'package:social_media_app/core/widget/custom_buttom.dart';
import 'package:social_media_app/core/widget/custom_text_from_filed.dart';
import 'package:social_media_app/features/auth/view_model/auth_view_model.dart';

class RegesterScreen extends StatefulWidget {
  const RegesterScreen({super.key});

  @override
  State<RegesterScreen> createState() => _RegesterScreenState();
}

class _RegesterScreenState extends State<RegesterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Icon(Icons.message, size: 60, color: Colors.blue),
                SizedBox(height: 40),
          
                CustomTextFromFiled(
                  lable: "name",
                  controller: nameController,
                  validator: (value) => authViewModel.validateName(value!),
                ),
                SizedBox(height: 10),
                CustomTextFromFiled(
                  lable: "email",
                  controller: emailController,
                  validator: (value) => authViewModel.validateEmail(value!),
                ),
                SizedBox(height: 10),
                CustomTextFromFiled(
                  lable: "password ",
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) => authViewModel.validatePassword(value!),
                ),
                SizedBox(height: 10),
          
                CustomButton(
                  label: "Regester",
                  color: Colors.blue,
                  borderColor: Colors.blue,
                  labelColor: Colors.white,
                  onPressed: register,
                ),
          
                SizedBox(height: 10),
          
                SizedBox(height: MediaQuery.of(context).size.height * 0.275),
                CustomButton(
                  label: "I already have an account",
                  color: Colors.white,
                  borderColor: Colors.blue,
                  labelColor: Colors.blue,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    if (globalKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      authViewModel
          .register(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((user) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("An error occurred: $error"),
                backgroundColor: Colors.red,
              ),
            );
          });
    }
  }
}
