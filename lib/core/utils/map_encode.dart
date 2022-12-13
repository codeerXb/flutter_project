class MapEncode {
  /// 将字节转为带单位格式
  static String toEncode(Map<String, dynamic> data) {
    String sdata = '';
    data.forEach((key, value) {
      sdata += '${key.toString()}=${value.toString()}&';
    });
    sdata = sdata.substring(0, sdata.length - 1);
    return Uri.encodeFull(sdata);
  }
}
