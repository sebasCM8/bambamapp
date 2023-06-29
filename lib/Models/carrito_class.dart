class Carrito {
  int carPro = 0;
  String carNombre = "";
  double carCant = 0;

  Map<String, dynamic> toDb() {
    Map<String, dynamic> item = {
      "carPro": carPro,
      "carNombre": carNombre,
      "carCant": carCant
    };
    return item;
  }

  void fromDb(Map<String, dynamic> item) {
    carPro = item["carPro"];
    carNombre = item["carNombre"];
    carCant = item["carCant"];
  }
}
