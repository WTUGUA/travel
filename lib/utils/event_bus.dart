//EventBus.dart
import 'package:event_bus/event_bus.dart';

//初始化Bus
EventBus eventBus = EventBus();

/**
 * 下面是定义全局监听的事件类
 * 后面根据需要依次在下面累加
 */


class LanguageEvent {
  String string;
  LanguageEvent(this.string);
}
class ListEvent{
  String string;
  ListEvent(this.string);
}