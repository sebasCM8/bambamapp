class GeneriOps{
  static bool checkValidEntero(String nro) {
    RegExp expr = RegExp(r"^[1-9][0-9]*$|^[0-9]$");
    bool resp = expr.hasMatch(nro);
    return resp;
  }
}