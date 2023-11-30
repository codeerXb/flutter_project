import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
///保存本地数据，获取本地数据
sharedAddAndUpdate(String key, Object dataType, Object data) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  switch (dataType) {
    case bool:
      sharedPreferences.setBool(key, data as bool);
      break;
    case double:
      sharedPreferences.setDouble(key, data as double);
      break;
    case int:
      sharedPreferences.setInt(key, data as int);
      break;
    case String:
      sharedPreferences.setString(key, data as String);
      break;
    case List:
      sharedPreferences.setStringList(key, data as List<String>);
      break;
    default:
      sharedPreferences.setString(key, data.toString());
      break;
  }
}

//读取数据
Future<Object?> sharedGetData(String key, Object dataType) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  switch (dataType) {
    case bool:
      return sharedPreferences.getBool(key);
    case double:
      return sharedPreferences.getDouble(key);
    case int:
      return sharedPreferences.getInt(key);
    case String:
      return sharedPreferences.getString(key);
    case List:
      return sharedPreferences.getStringList(key);
    default:
      return sharedPreferences.get(key);
  }
}

sharedDeleteData(String key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove(key);
}

sharedClearData() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
}

class Storage{
  static setData(String key,dynamic value) async{
      var prefs=await SharedPreferences.getInstance();
      prefs.setString(key, json.encode(value));
  }
  static getData(String key) async{
      var prefs=await SharedPreferences.getInstance();
      String? tempData=prefs.getString(key);
      return json.decode(tempData!);
  }
 static removeData(String key) async{
      var prefs=await SharedPreferences.getInstance();
      prefs.remove(key);    
  }
}