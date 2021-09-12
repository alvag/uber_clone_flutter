import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeController _homeController = new HomeController();

  @override
  Widget build(BuildContext context) {
    this._homeController.init(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.black, Colors.black87],
            ),
          ),
          child: Column(
            children: [
              _bannerApp(context),
              SizedBox(height: 50),
              Text(
                'SELECCIONA TU ROL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'OneDay',
                ),
              ),
              SizedBox(height: 30),
              _avatarTypeUser('assets/img/pasajero.png', context),
              SizedBox(height: 10),
              _textTypeUser('Cliente'),
              SizedBox(height: 30),
              _avatarTypeUser('assets/img/driver.png', context),
              SizedBox(height: 10),
              _textTypeUser('Conductor')
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerApp(BuildContext context) {
    return ClipPath(
      clipper: DiagonalPathClipperTwo(),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/img/logo_app.png', width: 150, height: 100),
            Text(
              'Fácil y Rápido',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textTypeUser(String typeUser) {
    return Text(typeUser, style: TextStyle(color: Colors.white, fontSize: 16));
  }

  Widget _avatarTypeUser(String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: _homeController.goToLoginPage,
      child: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
        radius: 50,
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}
