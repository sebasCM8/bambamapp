class Producto{
  int proId = 0;
  String proNombre = "";
  String proDesc = "";
  double proPrecio = 0;
  int proUni = 0;
  int proCat = 0;
  int proEstado = 0;
  String proUniNombre = "";
  String proCatNombre = "";
  double proStock = 0;

  void getFromApi(Map<String, dynamic> item){
    proId = item["proId"];
    proNombre = item["proNombre"];
    proDesc = item["proDesc"];
    proPrecio = item["proPrecio"];
    proUni = item["proUni"];
    proCat = item["proCat"];
    proEstado = item["proEstado"];
    proUniNombre = item["proUniNombre"];
    proCatNombre = item["proCatNombre"];
    proStock = item["proStock"];
  }
}