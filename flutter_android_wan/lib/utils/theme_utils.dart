import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_wan/common/constants.dart';
import 'package:flutter_android_wan/res/colors.dart';
import 'package:flutter_android_wan/utils/sp_utils.dart';

class ThemeUtils{
  /// 默认主题色
  static const Color defaultColor = Colors.redAccent;

  /// 当前的主题色
  static Color currentThemeColor = defaultColor;

  /// 是否是夜间模式
  static bool dark = false;

  static ThemeData getThemeData() {
    if (dark) {
      return new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF35464E),
        primaryColorDark: Color(0xFF212A2F),
        accentColor: Color(0xFF35464E),
        dividerColor: Color(0x1FFFFFFF),
      );
    } else {
      return new ThemeData(
        brightness: Brightness.light,
        primaryColor: currentThemeColor,
        primaryColorDark: currentThemeColor,
        accentColor: currentThemeColor,
        dividerColor: Color(0x1F000000),
      );
    }
  }

  static Future<Null> getTheme() async {
    bool dark = SpUtils.getBool(Constants.DARK_KEY, defValue: false);
    ThemeUtils.dark = dark;
    if (!dark) {
      String themeColorKey =
      SpUtils.getString(Constants.THEME_COLOR_KEY, defValue: 'redAccent');
      if (themeColorMap.containsKey(themeColorKey)) {
        ThemeUtils.currentThemeColor = themeColorMap[themeColorKey];
      }
    }
  }
  static setInsserbar(){
    if(Platform.isAndroid){
      //设置沉浸式状态栏
      SystemUiOverlayStyle systemUiOverlayStyle=
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}