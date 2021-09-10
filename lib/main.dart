import 'package:flutter/material.dart';
import 'package:uber_clone/pages/home/home_page.dart';

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
      theme: ThemeData(fontFamily: 'NimbusSans'),
      debugShowCheckedModeBanner: false,
      routes: {'home': (BuildContext context) => HomePage()},
    );
  }
}
