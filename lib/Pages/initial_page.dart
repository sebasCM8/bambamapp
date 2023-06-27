import 'package:flutter/material.dart';
import 'package:bambam_app/Controllers/usuario_ctrl.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPage();
}

class _InitialPage extends State<InitialPage> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  Future<void> checkSession() async {
    String usuId = await Future.delayed(
        const Duration(seconds: 1), () => UsuarioController.getUsuLogged());
    bool usuarioLogeado = (usuId != "");
    if (usuarioLogeado) {
      Navigator.pushReplacementNamed(context, "/homePage");
    } else {
      Navigator.pushReplacementNamed(context, "/loginPage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 8)),
    );
  }
}
