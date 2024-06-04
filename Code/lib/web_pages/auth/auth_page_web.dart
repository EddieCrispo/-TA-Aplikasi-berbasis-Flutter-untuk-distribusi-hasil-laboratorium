import 'package:firebasetutorial/web_pages/login_page_web.dart';
import 'package:firebasetutorial/web_pages/register_page_web.dart';
import 'package:flutter/material.dart';

class AuthPageWeb extends StatefulWidget {
  const AuthPageWeb({super.key});

  @override
  State<AuthPageWeb> createState() => _AuthPageWebState();
}

class _AuthPageWebState extends State<AuthPageWeb> {
  // Initially show the login page
  bool showLoginPageWeb = true;

  void toggleScreens() {
    setState(() {
      showLoginPageWeb = !showLoginPageWeb;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPageWeb) {
      return LoginPageWeb(showRegisterPageWeb: toggleScreens);
    } else {
      return RegisterPageWeb(
        showLoginPageWeb: toggleScreens,
      );
    }
  }
}
