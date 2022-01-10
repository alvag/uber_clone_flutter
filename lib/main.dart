// @dart=2.9
import 'package:flutter/material.dart';
import 'package:uber_clone/src/pages/client/map/client_map_page.dart';
import 'package:uber_clone/src/pages/client/register/client_register_page.dart';
import 'package:uber_clone/src/pages/driver/map/driver_map_page.dart';
import 'package:uber_clone/src/pages/driver/register/driver_register_page.dart';
import 'package:uber_clone/src/pages/home/home_page.dart';
import 'package:uber_clone/src/pages/login/login_page.dart';
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
        'client/register': (BuildContext context) => ClientRegisterPage(),
        'client/map': (BuildContext context) => ClientMapPage(),
        'driver/register': (BuildContext context) => DriverRegisterPage(),
        'driver/map': (BuildContext context) => DriverMapPage(),
      },
    );
  }
}
