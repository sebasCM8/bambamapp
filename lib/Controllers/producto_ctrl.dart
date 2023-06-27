import 'package:bambam_app/Models/api_class.dart';
import 'package:bambam_app/Models/producto_class.dart';
import 'package:bambam_app/Models/rrobtproducos_class.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductosController{
  static Future<RRObtProductos> obtenerProductos() async {
    RRObtProductos result = RRObtProductos();

    String theUrl = ApiEndpoints.apiObtenerProducto;
    final apiReq = await http.get(Uri.parse(theUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    var apiResp = jsonDecode(apiReq.body);
    result.resp.fromApi(apiResp);
    if (result.resp.ok) {
      for(var item in apiResp["productos"]){
        Producto prd = Producto();
        prd.getFromApi(item);
        result.productos.add(prd);
      }
    }

    return result;
  }
}