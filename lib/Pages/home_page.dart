import 'package:bambam_app/Controllers/usuario_ctrl.dart';
import 'package:bambam_app/Models/usuario_class.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Usuario _usu = Usuario();

  @override
  void initState() {
    super.initState();
    checkPassword();
  }

  Future<void> checkPassword() async {
    String usuId = await UsuarioController.getUsuLogged();
    setState(() {
      _usu.usuId = usuId;
    });
  }

  Future<void> logoutProc() async {
    await UsuarioController.destroySession();
    Navigator.pushNamedAndRemoveUntil(
        context, '/loginPage', (Route<dynamic> route) => false);
  }

  Future<void> confimarDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Seguro que desea cerrrar sesion?",
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "NO",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
              TextButton(
                  onPressed: () {
                    logoutProc();
                  },
                  child: const Text(
                    "SI SALIR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  ))
            ],
          );
        });
  }

  void productos(){
    Navigator.pushNamed(context, "/productosPage");
  }

  @override
  Widget build(BuildContext context) {
    Widget myDrawer = Drawer(
        child: ListView(children: [
      const SizedBox(
        height: 120,
        child: DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white),
            )),
      ),
      const SizedBox(
        height: 50,
      ),
      ListTile(
        title: const Text(
          "Productos"
        ),
        onTap: productos,
      ),
      const SizedBox(
        height: 20,
      ),
      ListTile(
        title: const Text(
          "Salir",
          style: TextStyle(color: Colors.red),
        ),
        onTap: () => confimarDialog(context),
      ),
    ]));

    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      drawer: myDrawer,
      body: Center(child: Text("Bienvenido ${_usu.usuId}")),
    );
  }
}
