class Usuario {
  String usuId = "";
  String usuPass = "";
  String usuNombre = "";
  String usuApellido = "";
  String usuCI = "";
  String usuCelular = "";
  int usuEstado = 0;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> rep = {
      "usuId": usuId,
      "usuPass": usuPass,
      "usuNombre": usuNombre,
      "usuApellido": usuApellido,
      "usuCI": usuCI,
      "usuCelular": usuCelular,
      "usuEstado": usuEstado
    };
    return rep;
  }

  void fromApi(Map<String, dynamic> item){
    usuId = item["usuId"];
    usuPass = item["usuPass"];
    usuNombre = item["usuNombre"];
    usuApellido = item["usuApellido"];
    usuCI = item["usuCI"];
    usuCelular = item["usuCelular"];
    usuEstado = item["usuEstado"];
  }
}
