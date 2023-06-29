import 'dart:io';

import 'package:bambam_app/Controllers/carrito_ctrl.dart';
import 'package:bambam_app/Controllers/usuario_ctrl.dart';
import 'package:bambam_app/Models/carrito_class.dart';
import 'package:bambam_app/Models/generic_class.dart';
import 'package:bambam_app/Models/pedido_class.dart';
import 'package:bambam_app/Models/resp_class.dart';
import 'package:bambam_app/Models/rrobtcarrito_class.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  bool _loading = false;
  List<Carrito> _items = [];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  Future<RRObtCarrito> getItemsProc() async {
    RRObtCarrito result = RRObtCarrito();
    try {
      result = await CarritoController.getItems();
    } catch (e) {
      result.resp.ok = false;
      result.resp.msg = "Excepcion al obtener items: $e";
    }
    return Future.delayed(const Duration(seconds: 1), () => result);
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

  Future<void> msgExito(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              msg,
              style: const TextStyle(color: Colors.green),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.popUntil(
                        context, ModalRoute.withName("/productosPage"));
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))
            ],
          );
        });
  }

  Future<void> getItems() async {
    setState(() {
      _loading = true;
    });

    RRObtCarrito procResp = await getItemsProc();
    if (procResp.resp.ok) {
      _items = List.from(procResp.items);
    } else {
      msgErrDialog(context, procResp.resp.msg);
    }

    setState(() {
      _loading = false;
    });
  }

  Widget itemsList() {
    return Expanded(
      child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return Container(
              margin:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.blueGrey,
                        offset: Offset(1, 1),
                        blurRadius: 4),
                    BoxShadow(
                        color: Colors.blueGrey,
                        offset: Offset(-1, -1),
                        blurRadius: 4)
                  ],
                  border: Border.all(
                      color: const Color(0xff37404a),
                      width: 2,
                      style: BorderStyle.solid),
                  borderRadius: const BorderRadius.all(Radius.circular(11))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_items[index].carNombre,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(_items[index].carCant.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))
                ],
              ),
            );
          }),
    );
  }

  Future<ResponseResult> ordenarProc() async {
    ResponseResult result = ResponseResult();

    try {
      Pedido ped = Pedido();
      ped.pedUsu = await UsuarioController.getUsuLogged();

      bool hasPermission = await GeneriOps.handleLocationPermission();
      if (!hasPermission) {
        result = ResponseResult.full(false, "Debe dar permiso de ubicacion");
        return result;
      }
      Location lc = Location();
      LocationData lcData = await lc.getLocation();
      ped.pedLat = lcData.latitude.toString();
      ped.pedLng = lcData.longitude.toString();

      result = await CarritoController.ordenarPedido(ped);
    } catch (e) {
      result.ok = false;
      result.msg = "Excepcion al ordenar pedido: $e";
    }

    return result;
  }

  Future<void> ordenarbtn() async {
    setState(() {
      _loading = true;
    });

    ResponseResult procResp = await ordenarProc();
    if (procResp.ok) {
      msgExito(context, procResp.msg);
    } else {
      msgErrDialog(context, procResp.msg);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var devSize = MediaQuery.of(context).size;

    Widget thelist = _items.isNotEmpty
        ? itemsList()
        : const SizedBox(
            height: 5,
          );
    return Scaffold(
      appBar: AppBar(title: const Text("Carrito")),
      body: Column(children: [
        const SizedBox(height: 25),
        thelist,
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
                      onPressed: ordenarbtn, child: const Text("ORDENAR"))))
      ]),
    );
  }
}
