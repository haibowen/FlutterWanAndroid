import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
///
/// 项目中的SP工具类
///
///
///
class SpUtils {
  static SpUtils _singleton;
  static SharedPreferences _perfs;
  static Future<SpUtils> getInstance() async {
    if (_singleton == null) {
      var singleton = SpUtils._();
      await singleton._init();
      _singleton = singleton;
    }
    return _singleton;
  }

  SpUtils._();

  Future _init() async {
    _perfs = await SharedPreferences.getInstance();
  }

//put object
  static Future<bool> putObject(String key, Object value) {
    if (_perfs == null) return null;
    return _perfs.setString(key, value == null ? "" : json.encode(value));
  }

  //get object
  static T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  //get onject
  static Map getObject(String key) {
    if (_perfs == null) return null;
    String _data = _perfs.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  //put object list
  static Future<bool> putObjectList(String key, List<Object> list) {
    if (_perfs == null) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _perfs.setStringList(key, _dataList);
  }

  //get  obj list
  static List<T> getObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  //get object list
  static List<Map> getObjectList(String key) {
    if (_perfs == null) return null;
    List<String> dataList = _perfs.getStringList(key);
    return dataList?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  //get String
  static String getString(String key, {String defValue = ""}) {
    if (_perfs == null) return defValue;
    return _perfs.getString(key) ?? defValue;
  }

  // put String
  static Future<bool> putString(String key, String value) {
    if (_perfs == null) return null;
    return _perfs.setString(key, value);
  }

  //get bool
  static bool getBool(String key, {bool defValue = false}) {
    if (_perfs == null) return defValue;
    return _perfs.getBool(key) ?? defValue;
  }

//put bool
  static Future<bool> putBool(String key, bool value) {
    if (_perfs == null) return null;
    return _perfs.setBool(key, value);
  }

  //get int
  static int getInt(String key, {int defValue = 0}) {
    if (_perfs == null) return defValue;
    return _perfs.getInt(key) ?? defValue;
  }

  //get int
  static Future<bool> putInt(String key, int value) {
    if (_perfs == null) return null;
    return _perfs.setInt(key, value);
  }

  //get double
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_perfs == null) return defValue;
    return _perfs.getDouble(key) ?? defValue;
  }

//put double
  static Future<bool> putDouble(String key, double value) {
    if (_perfs == null) return null;
    return _perfs.setDouble(key, value);
  }

  //get string list
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_perfs == null) return defValue;
    return _perfs.getStringList(key) ?? defValue;
  }

// put String list
  static Future<bool> putStringList(String key, List<String> value) {
    if (_perfs == null) return null;
    return _perfs.setStringList(key, value);
  }

  //get dynaic
  static dynamic getDynamic(String key, {Object defValue}) {
    if (_perfs == null) return defValue;
  }

  //have key
  static bool haveKey(String key) {
    if (_perfs == null) return null;
    return _perfs.getKeys().contains(key);
  }

// get keys
  static Set<String> getKeys() {
    if (_perfs == null) return null;
    return _perfs.getKeys();
  }

//remove
  static Future<bool> remove(String key) {
    if (_perfs == null) return null;
    return _perfs.remove(key);
  }

  //clear
  static Future<bool> clear() {
    if (_perfs == null) return null;
    return _perfs.clear();
  }

//sp is initialized
  static bool isInitialized() {
    return _perfs != null;
  }
}
