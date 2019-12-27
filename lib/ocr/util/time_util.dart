import 'package:intl/intl.dart';
class TimeUtils {
  static String transUnixTime(int timestamp) {
    print("time=$timestamp");
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp*1000);
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(date);
    print("timeResult=$formatted");
    return formatted;
  }
}
