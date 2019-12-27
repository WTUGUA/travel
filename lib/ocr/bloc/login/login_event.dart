import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
//设置匹配类
@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginActionEvent extends LoginEvent {
  @override
  String toString() {
    return "LoginEvent";
  }
}

class LogoutActionEvent extends LoginEvent {}

class LoginVipEvent extends LoginEvent {}

