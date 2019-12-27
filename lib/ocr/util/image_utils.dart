import 'dart:convert';
import 'dart:io';

class ImageUtils {
  /*
      * 通过图片路径将图片转换成Base64字符串
      */
  static Future image2Base64(String path) async {
    File file = new File(path);
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  static Future file2Base64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }
}
