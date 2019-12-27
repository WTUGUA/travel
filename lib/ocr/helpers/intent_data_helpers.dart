import "dart:convert";

class DataHelper {
  static String decodeData(String data) {
    var list = List<int>();
    jsonDecode(data).forEach(list.add);
    return Utf8Decoder().convert(list);
  }

  static String encodeData(String data) {
    return jsonEncode(Utf8Encoder().convert(data));
  }
}
