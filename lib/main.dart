import 'package:flutter/material.dart';
import 'package:uber_clone/pages/home/home_page.dart';
import 'package:uber_clone/pages/login/login_page.dart';
import 'package:uber_clone/utils/custom_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
        appBarTheme: AppBarTheme(elevation: 0),
        primaryColor: CustomColors.uberCloneColor,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage()
      },
    );
  }
}
