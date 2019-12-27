import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RouterEvent extends Equatable {
  RouterEvent([List props = const []]) : super(props);
}

//demo 主页
class RouterMain extends RouterEvent {}

//demo  orc识别
class RouterRec extends RouterEvent {}

//demo 分屏展示比对
class RouterComparison extends RouterEvent {}

// demo 翻译
class RouterTranslation extends RouterEvent {}

// demo 图片选择
class RouterPicImage extends RouterEvent {}

// demo 历史记录
class RouterHistory extends RouterEvent {}

//demo 拍照界面
class RouterCamera extends RouterEvent {}

//demo 图片预览
class RouterPreview extends RouterEvent {}
