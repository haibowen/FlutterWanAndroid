
import 'package:dio/dio.dart';
import 'package:flutter_android_wan/common/constants.dart';
import 'package:flutter_android_wan/model/user_model.dart';
import 'package:flutter_android_wan/utils/sp_utils.dart';

class User{
  static final User singleton=User._internal();

  factory User(){
    return singleton;
  }
  User._internal();
  List<String> cookie;
  String userName;
  void saveUserInfo(UserModel _userModel,Response response){
    List<String> cookies=response.headers["set-cookie"];
    cookie=cookies;
    userName=_userModel.data.username;
    saveInfo();
    
  }
  Future<Null> getUserInfo()async{
    List<String> cookies=SpUtils.getStringList(Constants.COOKIES_KEY);
    if(cookies!=null){
      cookie=cookies;
    }
    String username=SpUtils.getString(Constants.USERNAME_KEY);
    if(username!=null){
      username=username;
    }
  }
  saveInfo() async{
    SpUtils.putStringList(Constants.COOKIES_KEY, cookie);
    SpUtils.putString(Constants.USERNAME_KEY, userName);

  }
  void clearUserInfo(){
    cookie =null;
    userName=null;
    SpUtils.remove(Constants.COOKIES_KEY);
    SpUtils.remove(Constants.USERNAME_KEY);
  }

}