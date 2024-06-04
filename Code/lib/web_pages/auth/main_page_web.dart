import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetutorial/web_pages/auth/auth_page_web.dart';
import 'package:firebasetutorial/web_pages/home_page_web.dart';
import 'package:flutter/material.dart';

class MainPageWeb extends StatelessWidget {
  const MainPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePageWeb();
          } else {
            return AuthPageWeb();
          }
        },
      ),
    );
  }
}
