// @dart=2.9
import 'package:flutter/material.dart';
import 'package:uber_clone/src/pages/home/home_page.dart';
import 'package:uber_clone/src/pages/login/login_page.dart';
import 'package:uber_clone/src/pages/register/register_page.dart';
import 'package:uber_clone/src/utils/custom_colors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone',
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: CustomColors.uberCloneColor,
        ),
        primaryColor: CustomColors.uberCloneColor,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage()
      },
    );
  }
}
