import 'package:dio/dio.dart';
import 'package:flutter_android_wan/common/user.dart';
import 'package:flutter_android_wan/model/article_model.dart';
import 'package:flutter_android_wan/model/banner_model.dart';
import 'package:flutter_android_wan/net/dio_manager.dart';

import 'api.dart';

ApiService _apiService = new ApiService();

ApiService get apiService => _apiService;

class ApiService {
  Options _getOptions() {
    Map<String, String> map = new Map();
    map['Cookie'] = User().cookie.toString();
    return Options(headers: map);
  }

  ///获取首页轮播数据
  void getBannerList(Function callback) async {
    dio.get(Apis.HOME_BANNER).then((response) {
      callback(BannerModel.fromJson(response.data));
    });
  }
  ///获取首页置顶文章数据
 void getTopArticleList(Function callback,Function errorCallback)async{
    dio.get(Apis.HOME_TOP_ARTICLE_LIST).then((response){
      callback(TopArticleModel.fromJson(response.data));
    }).catchError((e){
      errorCallback(e);
    });
 }
 ///获取
}
