import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:traveltranslation/ocr/util/shared_preference.dart';

import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => UnLoginState();


  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    switch (event.runtimeType) {
      case LoginActionEvent:
        yield LoginWithOutVipState();
        break;
      case LogoutActionEvent:
        await _logout();
        yield UnLoginState();
        break;
      case LoginVipEvent:
        yield LoginWithVipState();
        break;
      default:
        yield _logout();
        break;
    }
  }

  //模拟登录返回结果
  _login() sync* {}

  _logout() sync* {}
}
