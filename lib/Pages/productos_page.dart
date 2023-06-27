import 'dart:convert';

import 'package:bambam_app/Controllers/producto_ctrl.dart';
import 'package:bambam_app/Models/categoria_class.dart';
import 'package:bambam_app/Models/producto_class.dart';
import 'package:bambam_app/Models/resp_class.dart';
import 'package:bambam_app/Models/rrobtproducos_class.dart';
import 'package:bambam_app/Models/unidad_class.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  bool _loading = false;
  String _msgErr = "";

  List<Producto> _fullProds = [];
  List<Producto> _productos = [];

  List<Unidad> _unidades = [];
  List<Categoria> _categorias = [];

  int _catSlct = 0;
  int _uniSlct = 0;

  @override
  void initState() {
    super.initState();
    getProductos();
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

  Future<RRObtProductos> getprodProc() async {
    RRObtProductos result = RRObtProductos();
    try {
      result = await ProductosController.obtenerProductos();
    } catch (e) {
      result.resp.ok = false;
      result.resp.msg = "Excepcion al obtener prods del servidor: $e";
    }
    return Future.delayed(const Duration(seconds: 1), () => result);
  }

  Future<void> getProductos() async {
    setState(() {
      _loading = true;
    });

    RRObtProductos procResp = await getprodProc();
    if (procResp.resp.ok) {
      _fullProds = List.from(procResp.productos);
      _productos = List.from(procResp.productos);

      for (Producto prd in _productos) {
        bool nuevaUni = _unidades.every((u) => u.uniId != prd.proUni);
        if (nuevaUni) {
          Unidad uni = Unidad();
          uni.uniId = prd.proUni;
          uni.uniNombre = prd.proUniNombre;
          _unidades.add(uni);
        }

        bool nuevaCat = _categorias.every((c) => c.catId != prd.proCat);
        if (nuevaCat) {
          Categoria cat = Categoria();
          cat.catId = prd.proCat;
          cat.catNombre = prd.proCatNombre;
          _categorias.add(cat);
        }
      }
    } else {
      msgErrDialog(context, procResp.resp.msg);
    }

    setState(() {
      _loading = false;
    });
  }

  Widget unidadesSlct() {
    List<DropdownMenuItem> opts = [];
    opts.add(const DropdownMenuItem(
      child: Text("TODAS"),
      value: 0,
    ));
    for (Unidad u in _unidades) {
      DropdownMenuItem opt =
          DropdownMenuItem(value: u.uniId, child: Text(u.uniNombre));
      opts.add(opt);
    }
    return DropdownButton(
        items: opts,
        value: _uniSlct,
        onChanged: (dynamic val) {
          setState(() {
            _uniSlct = val;
            applyFilter();
          });
        });
  }

  Widget categoriasSlct() {
    List<DropdownMenuItem> opts = [];
    opts.add(const DropdownMenuItem(
      child: Text("TODAS"),
      value: 0,
    ));
    for (Categoria c in _categorias) {
      String nom = c.catNombre;
      if (nom.length > 10) {
        nom = nom.substring(0, 10);
      }
      DropdownMenuItem opt = DropdownMenuItem(value: c.catId, child: Text(nom));
      opts.add(opt);
    }
    return DropdownButton(
        items: opts,
        value: _catSlct,
        onChanged: (dynamic val) {
          setState(() {
            _catSlct = val;
            applyFilter();
          });
        });
  }

  void applyFilter() {
    bool changed = false;
    if (_uniSlct != 0) {
      changed = true;
      _productos.clear();
      for (Producto prd in _fullProds) {
        if (prd.proUni == _uniSlct) {
          _productos.add(prd);
        }
      }
    }

    if (_catSlct != 0) {
      List<Producto> srcList =
          changed ? List.from(_productos) : List.from(_fullProds);
      changed = true;
      _productos.clear();
      for (Producto prd in srcList) {
        if (prd.proCat == _catSlct) {
          _productos.add(prd);
        }
      }
    }

    if (!changed) {
      _productos.clear();
      _productos = List.from(_fullProds);
    }
  }

  Widget productosList() {
    List<Widget> prdList = [];
    for (Producto prd in _productos) {
      Color thecolor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0);
      Widget prdCard = InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/productoDetallePage", arguments: prd);
        },
        child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: thecolor,
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
            alignment: Alignment.center,
            child: Text(
              prd.proNombre,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            )),
      );
      prdList.add(prdCard);
    }
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: prdList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget filtro = (_unidades.isNotEmpty && _categorias.isNotEmpty)
        ? Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Unidad: "),
                unidadesSlct(),
                const Text("Categoria: "),
                categoriasSlct()
              ],
            ),
          )
        : const SizedBox(
            height: 2,
          );

    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),
      body: Column(children: [
        filtro,
        if (_productos.isNotEmpty) productosList(),
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
