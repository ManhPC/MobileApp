class NiceNum {
  String stk;
  String giatri;
  NiceNum(this.stk, this.giatri);
  factory NiceNum.fromJson(Map<String, dynamic> json) {
    return NiceNum(json['stk'], json['giatri']);
  }
}
