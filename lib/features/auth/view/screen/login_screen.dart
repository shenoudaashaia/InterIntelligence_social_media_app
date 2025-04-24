// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/features/auth/view/screen/regester_screen.dart';
import 'package:social_media_app/features/auth/view_model/auth_view_model.dart';
import 'package:social_media_app/home_screen.dart';
import 'package:social_media_app/core/widget/custom_buttom.dart';
import 'package:social_media_app/core/widget/custom_text_from_filed.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                const Icon(Icons.message, size: 60, color: Colors.blue),
                const SizedBox(height: 40),
                CustomTextFromFiled(lable: "email", controller: emailController),
                const SizedBox(height: 10),
                CustomTextFromFiled(
                  lable: "password ",
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                authViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                      label: "login",
                      color: Colors.blue,
                      borderColor: Colors.blue,
                      labelColor: Colors.white,
                      onPressed: login,
                    ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                CustomButton(
                  label: "create new account",
                  color: Colors.white,
                  borderColor: Colors.blue,
                  labelColor: Colors.blue,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegesterScreen()),
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

  void login() {
    if (globalKey.currentState!.validate()) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      authViewModel
          .login(emailController.text.trim(), passwordController.text.trim())
          .then((_) {
            if (authViewModel.user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else {
              _showError(authViewModel.errorMessage);
            }
          })
          .catchError((error) {
            _showError("An error occurred: $error");
          });
    }
  }

  void _showError(String? errorMessage) {
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }
}
