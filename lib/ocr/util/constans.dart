class LanguageUtil {
  static String auto = "auto";
  static String zh = "zh"; //中文
  static String en = "en"; //英文
  static String yue = "yue"; //粤语
  static String wyw = "wyw"; //文言文
  static String jp = "jp"; //日文
  static String kor = "kor"; //韩文
  static String fra = "fra"; //法语

//    - CHN_ENG：中英文混合；
//    - ENG：英文；
//    - POR：葡萄牙语；
//    - FRE：法语；
//    - GER：德语；
//    - ITA：意大利语；
//    - SPA：西班牙语；
//    - RUS：俄语；
//    - JAP：日语

  static var languageMap = {
    '中英文混合': 'CHN_ENG',
    '英文': 'ENG',
    '葡萄牙语': 'POR',
    '法语': 'FRE',
    '德语': 'GER',
    '意大利语': 'ITA',
    '西班牙语': 'SPA',
    '俄语': 'RUS',
    '日语': 'JAP',
  };

  static var translateMap = {
    '中文': 'zh',
    '英语': 'en',
    '粤语': 'yue',
    '文言文': 'wyw',
    '日语': 'jp',
    '韩语': 'kor',
    '法语': 'fra',
    '西班牙语': 'spa',
    '泰语': 'th',
    '阿拉伯语': 'ara',
    '俄语': 'ru',
    '葡萄牙语': 'pt',
    '德语': 'de',
    '意大利语': 'it',
    '希腊语': 'el',
    '荷兰语': 'nl',
    '保加利亚语': 'bul',
    '爱沙尼亚语': 'est',
    '丹麦语': 'dan',
    '芬兰语': 'fin',
    '捷克语': 'cs',
    '罗马尼亚语': 'rom',
    '斯洛文尼亚语': 'slo',
    '瑞典语': 'swe',
    '匈牙利语': 'hu',
    '繁体中文': 'cht',
    '越南语': 'vie',
  };
}

class Constants {
  //ocr上线需要的appid
  static final String ocr_key = "ALj4mQo1O496ZGZ9vqSz2XeF";
  static final String ocr_secret = "Y9sRy3a6hPXRdaTUeG9IPktte9gOETwr";


  //ios测试appkey
//  static final String ocr_key = "cersK9LgZssgvfAncLMS5X4Y";
//  static final String ocr_secret = "7XoDo3MGkabHTrBfUmECmHo6l5MrOKZv";


  //这个是百度翻译API需要得
  static String appId = "20190809000325332";
  static String tranSecret = "luTbBoWAQY3uGV8rtxog";
}

const int WechatPay = 0;
const int AliPay = 1;
