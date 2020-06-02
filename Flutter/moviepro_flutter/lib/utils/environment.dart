/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-18 16:56:36
 * @LastEditTime: 2020-05-27 19:53:47
 * @LastEditors:  
 */

enum EnvironmentType { unknown, ios, android }

final Environment environment = Environment();
class Environment {
  static EnvironmentType _type = EnvironmentType.unknown;
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");  
  static bool get isAndroid => _type == EnvironmentType.android;
  static bool get isIOS => _type == EnvironmentType.ios;
}

class Theme {
  static Theme shared = Theme(); 
  factory Theme() => Environment.isIOS ? IOSTheme() : AndroidTheme();
  updateTheme() { AssertionError('需要具体实现'); }
}

class IOSTheme implements Theme {
  @override
  updateTheme() {
    return null;
  } 
}

class AndroidTheme implements Theme {
  @override
  updateTheme() {
    return null;
  } 
}

void main() {
  final theme = Theme();
}
