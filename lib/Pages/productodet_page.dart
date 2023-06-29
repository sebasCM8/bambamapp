import 'package:bambam_app/Controllers/carrito_ctrl.dart';
import 'package:bambam_app/Models/carrito_class.dart';
import 'package:bambam_app/Models/generic_class.dart';
import 'package:bambam_app/Models/producto_class.dart';
import 'package:bambam_app/Models/resp_class.dart';
import 'package:bambam_app/Pages/mywidgets.dart';
import 'package:flutter/material.dart';

class ProductoDetPage extends StatefulWidget {
  final Producto prd;
  const ProductoDetPage({super.key, required this.prd});

  @override
  State<ProductoDetPage> createState() => _ProductoDetPageState();
}

class _ProductoDetPageState extends State<ProductoDetPage> {
  final _cantCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _cantCtrl.dispose();
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

  Future<ResponseResult> guardaritemproc() async {
    ResponseResult result = ResponseResult();
    try {
      Carrito item = Carrito();
      item.carPro = widget.prd.proId;
      item.carNombre = widget.prd.proNombre;

      if (!GeneriOps.checValidFloat(_cantCtrl.text)) {
        result.ok = false;
        result.msg = "Cantidad invalida";
        return result;
      }
      item.carCant = double.parse(_cantCtrl.text);
      result = await CarritoController.guardarItem(item);
    } catch (e) {
      result.ok = false;
      result.msg = "Excepcion al guardar item: $e";
    }

    return result;
  }

  Future<void> guardarItemBtn() async {
    setState(() {
      _loading = true;
    });

    ResponseResult procresp = await guardaritemproc();
    if (procresp.ok) {
      Navigator.pop(context);
    } else {
      msgErrDialog(context, procresp.msg);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var devSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de producto")),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.only(left: 30, top: 30, bottom: 15),
          child: Row(
            children: [
              const Text(
                "Nombre: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.prd.proNombre,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, top: 30, bottom: 15),
          child: Row(
            children: [
              const Text(
                "Descripcion: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  widget.prd.proDesc,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, top: 30, bottom: 15),
          child: Row(
            children: [
              const Text(
                "Unidad de medida: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.prd.proUniNombre,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, top: 30, bottom: 15),
          child: Row(
            children: [
              const Text(
                "Categoria: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.prd.proCatNombre,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, top: 30, bottom: 15),
          child: Row(
            children: [
              const Text(
                "Precio: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.prd.proPrecio.toString(),
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        inputOne(_cantCtrl, "Cantidad...", 5),
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
                      onPressed: guardarItemBtn,
                      child: const Text("AÑADIR AL CARRO"))))
      ]),
    );
  }
}
