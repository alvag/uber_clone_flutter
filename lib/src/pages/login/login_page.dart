import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber_clone/src/pages/login/login_controller.dart';
import 'package:uber_clone/src/utils/custom_colors.dart';
import 'package:uber_clone/src/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController _loginController = new LoginController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _loginController.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textDescription(),
            _textLogin(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            _textFieldEmail(),
            _textFieldPassword(),
            _loginButton(),
            _textDontHaveAccount(),
          ],
        ),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return GestureDetector(
      onTap: _loginController.goToRegister,
      child: Container(
        margin: EdgeInsets.only(bottom: 70),
        child: Text(
          '¿No tienes cuenta?',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: CustomButton(
        onPressed: _loginController.login,
        btnColor: CustomColors.uberCloneColor,
        text: 'Iniciar sesión',
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _loginController.emailController,
        decoration: InputDecoration(
          hintText: 'correo@gmail.com',
          labelText: 'Correo electrónico',
          suffixIcon: Icon(
            Icons.email_outlined,
            color: CustomColors.uberCloneColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _loginController.pwdController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          suffixIcon: Icon(
            Icons.lock_open_outlined,
            color: CustomColors.uberCloneColor,
          ),
        ),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        'Continua con tu',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 24,
          fontFamily: 'NimbusSans',
        ),
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: CustomColors.uberCloneColor,
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/img/logo_app.png', width: 150, height: 100),
            Text(
              'Fácil y Rápido',
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
