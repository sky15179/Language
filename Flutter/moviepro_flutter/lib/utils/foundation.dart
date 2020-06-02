/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-04-24 17:14:10
 * @LastEditTime: 2020-05-20 12:52:29
 * @LastEditors:  
 */
extension StringExtension on String{
  
  /// 是否是电话号码
  bool get isMobileNumber {
    if(this?.isNotEmpty != true) return false;
    return RegExp(r'^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8])|(19)[0-9])\d{8}$').hasMatch(this);
  }
}

extension BoolExtension on bool {
  bool not() {
    return !this;
  }

  bool and(bool val) {
    return this && val;
  }

  bool or(bool val) {
    return this || val;
  }
}

extension AllExtension<T> on T {
  T apply(f(T e)) {
    f(this);
    return this;
  }

  R let<R>(R f(T e)) {
    return f(this);
  }
}
