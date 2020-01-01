

import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_wan/common/constants.dart';
import 'package:flutter_android_wan/common/router_config.dart';
import 'package:flutter_android_wan/common/user.dart';
import 'package:flutter_android_wan/page/splash_sereen.dart';
import 'package:flutter_android_wan/utils/sp_utils.dart';
import 'package:flutter_android_wan/utils/theme_utils.dart';

import 'common/application.dart';
import 'event/theme_change_event.dart';
import 'net/dio_manager.dart';


//在拿不到context的地方可以 通过 navigatorKey 跳转
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtils.getInstance();//实例化 sp

  await ThemeUtils.getTheme();//初始化主题
  runApp(MyApp());
  ThemeUtils.setInsserbar();//设置沉浸式状态栏

}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

}

class MyAppState extends State<MyApp>{
  ThemeData themeData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAsync();
    Application.eventBus=new EventBus();
    themeData=ThemeUtils.getThemeData();
    this.registerThemeEvent();

  }
  void _initAsync() async{
    await User().getUserInfo();
    await DioManager.init();
  }
  void registerThemeEvent(){
    Application.eventBus
        .on<ThemeChangeEvent>()
        .listen((ThemeChangeEvent onData)=>this.changeTheme(onData));

  }
  void changeTheme(ThemeChangeEvent onData)async{
    setState(() {
      themeData=ThemeUtils.getThemeData();
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routes: Router.generateRoute(),
      navigatorKey: navigatorKey,
      home:new SplashScreen() ,
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Application.eventBus.destroy();
  }


}

