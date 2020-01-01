import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_android_wan/common/router_config.dart';
import 'package:flutter_android_wan/common/user.dart';
import 'package:flutter_android_wan/utils/sp_utils.dart';
import 'package:flutter_android_wan/utils/toast_util.dart';

import '../../main.dart';
import '../dio_manager.dart';



/// WanAndroid 统一接口返回格式错误检测
class WanAndroidErrorInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    return options;
  }

  @override
  onError(DioError error) async {
    String errorMsg = DioManager.handleError(error);
    T.show(msg: errorMsg);
    return error;
  }

  @override
  onResponse(Response response) async {
    var data = response.data;

    if (data is String) {
      data = json.decode(data);
    }
    if (data is Map) {
      int errorCode = data['errorCode'] ?? 0;
      String errorMsg = data['errorMsg'] ?? '请求失败[$errorCode]';
      if (errorCode == 0) {
        return response;
      } else if (errorCode == -1001 /*未登录错误码*/) {
        User().clearUserInfo();
        dio.clear();
        SpUtils.clear();
        goLogin();
        return dio.reject(errorMsg);
      } else {
        T.show(msg: errorMsg);
        return dio.reject(errorMsg);
      }
    }

    return response;
  }

  void goLogin() {
    /// 在拿不到context的地方通过navigatorKey进行路由跳转：
    /// https://stackoverflow.com/questions/52962112/how-to-navigate-without-context-in-flutter-app
    navigatorKey.currentState.pushNamed(RouterName.login);
  }
}
