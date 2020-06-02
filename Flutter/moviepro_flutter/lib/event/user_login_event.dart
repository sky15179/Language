/*
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-06 16:32:58
 * @LastEditTime: 2020-05-06 16:33:44
 * @LastEditors:  
 */

import 'package:event_bus/event_bus.dart';

class User {
  final String name;
  final int id;

  User(this.name, this.id);
}

class UserLoginEvent {
  final User user;
  UserLoginEvent(this.user);
}

class ApplicationEvent {
  static EventBus event;
}