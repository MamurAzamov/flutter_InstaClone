import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/pages/home_page.dart';
import 'package:insta_clone/pages/signin_page.dart';
import 'package:insta_clone/pages/signup_page.dart';
import 'package:insta_clone/pages/splash_page.dart';
import 'package:insta_clone/pages/users_page.dart';
import 'package:insta_clone/services/notif_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotifService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        SignInPage.id: (context) => SignInPage(),
        SignUpPage.id: (context) => SignUpPage(),
        UserPage.id: (context) => UserPage()
      },
    );
  }
}