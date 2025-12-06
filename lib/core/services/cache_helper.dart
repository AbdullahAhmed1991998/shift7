import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreference;

  Future<void> cacheInit() async {
    sharedPreference = await SharedPreferences.getInstance();
  }

  Future<bool> setData({required String key, required dynamic value}) async {
    if (value is bool) {
      await sharedPreference.setBool(key, value);
      return true;
    }
    if (value is String) {
      await sharedPreference.setString(key, value);
      return true;
    }
    if (value is int) {
      await sharedPreference.setInt(key, value);
      return true;
    }
    if (value is double) {
      await sharedPreference.setDouble(key, value);
      return true;
    }
    return false;
  }

  dynamic getData({required String key}) {
    return sharedPreference.get(key);
  }

  dynamic deleteItem({required String key}) {
    sharedPreference.remove(key);
  }
}
