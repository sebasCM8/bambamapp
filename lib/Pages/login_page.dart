import 'package:bambam_app/Controllers/usuario_ctrl.dart';
import 'package:bambam_app/Models/usuario_class.dart';
import 'package:flutter/material.dart';
import 'package:bambam_app/Pages/mywidgets.dart';
import 'package:bambam_app/Models/resp_class.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usuIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  String _msgErr = "";

  @override 
  void dispose(){
    _usuIdCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> msgErrDialog(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              msg,
              style: const TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))
            ],
          );
        });
  }

  Future<void> loginBtn() async {
    setState(() {
      _loading = true;
    });

    _msgErr = "";
    ResponseResult procResp = await _loginProc();
    if (procResp.ok) {
      Navigator.pushReplacementNamed(context, "/homePage");
    } else {
      _msgErr = procResp.msg;
      msgErrDialog(context, _msgErr);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<ResponseResult> _loginProc() async {
    ResponseResult result;
    try {
      if (_usuIdCtrl.text == "") {
        result = ResponseResult.full(false, "Usuario no valido");
        return result;
      }
      if (_passwordCtrl.text == "") {
        result = ResponseResult.full(false, "Contraseña no valida");
        return result;
      }
      Usuario usu = Usuario();
      usu.usuId = _usuIdCtrl.text;
      usu.usuPass = _passwordCtrl.text;
      result = await UsuarioController.loginUsr(usu);
    } catch (e) {
      result = ResponseResult.full(false, "Excepcion: $e");
    }
    return Future.delayed(const Duration(seconds: 2), () => result);
  }

  @override
  Widget build(BuildContext context) {
    var devSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Ingresar")),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        inputOne(_usuIdCtrl, "Email....", 200),
        inputOne(_passwordCtrl, "Contraseña....", 50),
        if (_loading)
          Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
        if (!_loading)
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: devSize.width * 0.75,
                  child: ElevatedButton(
                      onPressed: loginBtn, child: const Text("INGRESAR")))),
        const SizedBox(
          height: 25,
        ),
        if (!_loading)
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: devSize.width * 0.75,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlue)),
                      onPressed: (){
                        Navigator.pushNamed(context, "/registroPage");
                      },
                      child: const Text("REGISTRARME"))))
      ]),
    );
  }
}
