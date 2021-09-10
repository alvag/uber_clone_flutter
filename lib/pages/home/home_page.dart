import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.black, Colors.black87]),
          ),
          child: Column(
            children: [
              ClipPath(
                clipper: DiagonalPathClipperTwo(),
                child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/img/logo_app.png',
                          width: 150,
                          height: 100,
                        ),
                        Text('Fácil y Rápido',
                            style: TextStyle(
                                fontFamily: 'Pacifico',
                                fontSize: 22,
                                fontWeight: FontWeight.bold))
                      ]),
                ),
              ),
              SizedBox(height: 50),
              Text(
                'SELECCIONA TU ROL',
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: 'OneDay'),
              ),
              SizedBox(height: 30),
              _avatarTypeUser('assets/img/pasajero.png'),
              SizedBox(height: 10),
              _textTypeUser('Cliente'),
              SizedBox(height: 30),
              _avatarTypeUser('assets/img/driver.png'),
              SizedBox(height: 10),
              _textTypeUser('Conductor')
            ],
          ),
        ),
      ),
    );
  }

  Widget _textTypeUser(String typeUser) {
    return Text(
      typeUser,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }

  Widget _avatarTypeUser(String imagePath) {
    return CircleAvatar(
      backgroundImage: AssetImage(imagePath),
      radius: 50,
      backgroundColor: Colors.grey[900],
    );
  }
}
