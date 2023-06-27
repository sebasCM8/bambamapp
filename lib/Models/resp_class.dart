class ResponseResult {
  bool ok = false;
  String msg = "";
  
  ResponseResult();
  
  ResponseResult.full(dOk, dMsg) {
    ok = dOk;
    msg = dMsg;
  }

  void fromApi(Map<String, dynamic> item){
    ok = item["ok"];
    msg = item["msg"];
  }
}
