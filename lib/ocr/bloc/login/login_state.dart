import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super(props);
}

//未登录状态
class UnLoginState extends LoginState {}

//登录但是非vip
class LoginWithOutVipState extends LoginState {}

//登录切是vip
class LoginWithVipState extends LoginState {}
