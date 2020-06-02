/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-07 12:08:52
 * @LastEditTime: 2020-05-27 16:16:16
 * @LastEditors:  
 */

// import 'package:shared_preferences/shared_preferences.dart';

// class Global {
//   SharedPreferences sharePreferences;
// }


T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}
