import 'package:bambam_app/Models/producto_class.dart';
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
        if (!_loading)
          Align(
              alignment: Alignment.center,
              child: Container(
                  width: devSize.width * 0.75,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/registroPage");
                      },
                      child: const Text("AÑADIR AL CARRO"))))
      ]),
    );
  }
}
