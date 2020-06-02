/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-04-28 17:06:15
 * @LastEditTime: 2020-04-30 17:54:38
 * @LastEditors:  
 */
import './baseModel.dart';

class MYPListModel extends MYPModel {
  String name;
  String desc;
  String icon;

  MYPListModel({this.name, this.desc, this.icon});

  MYPListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc = json['desc'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['desc'] = name;
    data['icon'] = name;
    return data;
  }
}