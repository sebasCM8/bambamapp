import 'package:bambam_app/Models/api_class.dart';
import 'package:bambam_app/Models/resp_class.dart';
import 'package:bambam_app/Models/usuario_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UsuarioController{
  static const String cUSUID = "usuId";

  static Future<String> getUsuLogged() async {
    final prefs = await SharedPreferences.getInstance();
    String currentUsu = prefs.getString(cUSUID) ?? "";
    return currentUsu;
  }

  static Future<void> destroySession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cUSUID);
  }

  static Future<void> createSession(String usuId) async {
    final prefs = await SharedPreferences.getInstance();
    String currentUsu = prefs.getString(cUSUID) ?? "";
    if (currentUsu != "") {
      await destroySession();
    }
    await prefs.setString(cUSUID, usuId);
  }

  static Future<ResponseResult> loginUsr(Usuario usu) async {
    ResponseResult result = ResponseResult();

    Map<String, dynamic> theData = usu.toMap();
    String theUrl = ApiEndpoints.apiLogin;
    final apiReq = await http.post(Uri.parse(theUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(theData));
    var apiResp = jsonDecode(apiReq.body);
    result.fromApi(apiResp);
    if (result.ok) {
      await createSession(usu.usuId);
    }

    return result;
  }

  static Future<ResponseResult> registrarUsuario(Usuario usu) async {
    ResponseResult result = ResponseResult();

    Map<String, dynamic> theData = usu.toMap();
    String theUrl = ApiEndpoints.apiRegistrar;
    final apiReq = await http.post(Uri.parse(theUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(theData));
    var apiResp = jsonDecode(apiReq.body);
    result.fromApi(apiResp);
    if (result.ok) {
      await createSession(usu.usuId);
    }

    return result;
  }
}