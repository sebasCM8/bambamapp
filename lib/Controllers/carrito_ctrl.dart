import 'dart:convert';

import 'package:bambam_app/Models/api_class.dart';
import 'package:bambam_app/Models/carrito_class.dart';
import 'package:bambam_app/Models/pedido_class.dart';
import 'package:bambam_app/Models/resp_class.dart';
import 'package:bambam_app/Models/rrobtcarrito_class.dart';
import 'package:bambam_app/dbs/dbhelper.dart';
import 'package:http/http.dart' as http;

class CarritoController {
  static Future<ResponseResult> guardarItem(Carrito item) async {
    ResponseResult result = ResponseResult();
    DBHelper dbh = DBHelper();
    final db = await dbh.openDB();
    var itemX = await db
        .query("Carrito", where: "carPro = ?", whereArgs: [item.carPro]);

    if (itemX.isNotEmpty) {
      await db.update("Carrito", item.toDb(),
          where: "carPro = ?", whereArgs: [item.carPro]);
    } else {
      await db.insert("Carrito", item.toDb());
    }

    await db.close();
    result.msg = "Item guardado";
    result.ok = true;

    return result;
  }

  static Future<bool> hayItems() async {
    DBHelper dbh = DBHelper();
    final db = await dbh.openDB();
    var items = await db.query("Carrito");
    await db.close();
    if (items.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<RRObtCarrito> getItems() async {
    DBHelper dbh = DBHelper();
    final db = await dbh.openDB();

    RRObtCarrito result = RRObtCarrito();
    var theitems = await db.query("Carrito");
    if (theitems.isNotEmpty) {
      for (var i in theitems) {
        Carrito car = Carrito();
        car.fromDb(i);
        result.items.add(car);
      }
    }

    await db.close();
    result.resp.ok = true;
    result.resp.msg = "Items obtenidos";
    return result;
  }

  static Future<ResponseResult> ordenarPedido(Pedido ped) async {
    ResponseResult result = ResponseResult();

    DBHelper dbh = DBHelper();
    final db = await dbh.openDB();

    var theitems = await db.query("Carrito");
    List<Map<String, dynamic>> items = [];
    for (var i in theitems) {
      Carrito car = Carrito();
      car.fromDb(i);
      items.add(car.toDb());
    }
    Map<String, dynamic> theData = {"pedido": ped.toApi(), "detalle": items};
    String theUrl = ApiEndpoints.apiRegPedido;
    final apiReq = await http.post(Uri.parse(theUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(theData));
    var apiResp = jsonDecode(apiReq.body);
    result.fromApi(apiResp);

    await db.delete("Carrito");
    await db.close();

    return result;
  }
}
