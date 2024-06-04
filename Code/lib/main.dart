import 'package:firebasetutorial/firebase_options.dart';
// import 'package:firebasetutorial/pages/login_page.dart';
import 'package:firebasetutorial/auth/main_page.dart';
import 'package:firebasetutorial/web_pages/auth/main_page_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget homePage;
    // Choose the appropriate home page based on the platform
    if (kIsWeb) {
      homePage = const MainPageWeb();
    } else {
      homePage = const MainPage();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage,
      // routes: {'/homepage': (context) => HomePage()},
      // theme: ThemeData(primarySwatch: Colors.deepPurple),
    );
  }
}
