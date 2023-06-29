class Pedido {
  String pedId = "";
  String pedUsu = "";
  String pedLat = "";
  String pedLng = "";
  String pedFecha = "";
  int pedEstado = 0;

  Map<String, dynamic> toApi() {
    Map<String, dynamic> item = {
      "pedId": pedId,
      "pedUsu": pedUsu,
      "pedLat": pedLat,
      "pedLng": pedLng,
      "pedFecha": pedFecha,
      "pedEstado": pedEstado
    };
    return item;
  }
}
