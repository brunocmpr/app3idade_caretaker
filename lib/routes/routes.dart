import 'package:app3idade_caretaker/views/home_page.dart';
import 'package:app3idade_caretaker/views/login_page.dart';
import 'package:app3idade_caretaker/views/user_register_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const login = "/";
  static const homePage = "/homepage";
  static const userRegisterPage = "/user_register";

  static Map<String, Widget Function(BuildContext)> get routes => {
        login: (context) => const LoginPage(),
        homePage: (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as String;
          return HomePage(token: arguments);
        },
        userRegisterPage: (context) => const UserRegisterPage(),
      };
}
