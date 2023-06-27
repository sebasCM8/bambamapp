import 'package:bambam_app/Controllers/usuario_ctrl.dart';
import 'package:bambam_app/Models/generic_class.dart';
import 'package:bambam_app/Models/usuario_class.dart';
import 'package:flutter/material.dart';
import 'package:bambam_app/Pages/mywidgets.dart';
import 'package:bambam_app/Models/resp_class.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final _usuIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _ciCtrl = TextEditingController();
  final _celularCtrl = TextEditingController();
  bool _loading = false;

  String _msgErr = "";

  @override 
  void dispose(){
    _usuIdCtrl.dispose();
    _passwordCtrl.dispose();
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _ciCtrl.dispose();
    _celularCtrl.dispose();
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

  Future<void> regBtn() async {
    setState(() {
      _loading = true;
    });

    _msgErr = "";
    ResponseResult procResp = await _regProc();
    if (procResp.ok) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/homePage', (Route<dynamic> route) => false);
    } else {
      _msgErr = procResp.msg;
      msgErrDialog(context, _msgErr);
    }

    setState(() {
      _loading = false;
    });
  }

  Future<ResponseResult> _regProc() async {
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
      if (_nombreCtrl.text == "") {
        result = ResponseResult.full(false, "Nombre no valido");
        return result;
      }
      if (_apellidosCtrl.text == "") {
        result = ResponseResult.full(false, "Apellidos no validos");
        return result;
      }
      if (!GeneriOps.checkValidEntero(_ciCtrl.text)) {
        result = ResponseResult.full(false, "CI no valido");
        return result;
      }
      if (!GeneriOps.checkValidEntero(_celularCtrl.text)) {
        result = ResponseResult.full(false, "Celular no valido");
        return result;
      }
      Usuario usu = Usuario();
      usu.usuId = _usuIdCtrl.text;
      usu.usuPass = _passwordCtrl.text.trim();
      usu.usuNombre = _nombreCtrl.text.trim();
      usu.usuApellido = _apellidosCtrl.text.trim();
      usu.usuCelular = _celularCtrl.text;
      usu.usuCI = _ciCtrl.text;
      usu.usuEstado = 1;
      result = await UsuarioController.registrarUsuario(usu);
    } catch (e) {
      result = ResponseResult.full(false, "Excepcion: $e");
    }
    return Future.delayed(const Duration(seconds: 2), () => result);
  }

  @override
  Widget build(BuildContext context) {
    var devSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: ListView(children: [
        const SizedBox(
          height: 20,
        ),
        inputOne(_nombreCtrl, "Nombre....", 200),
        inputOne(_apellidosCtrl, "Apellidos....", 50),
        inputOne(_ciCtrl, "CI....", 200),
        inputOne(_celularCtrl, "Celular....", 50),
        inputOne(_usuIdCtrl, "Usuario....", 200),
        inputOne(_passwordCtrl, "Contraseña....", 50),
        if (!_loading)
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: devSize.width * 0.75,
                  child: ElevatedButton(
                      onPressed: regBtn, child: const Text("INGRESAR")))),
        if (_loading)
          Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
      ]),
    );
  }
}
