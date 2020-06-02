/*
 * @Description: 模型
 * @Author: 王智刚
 * @Date: 2020-04-30 11:57:17
 * @LastEditTime: 2020-04-30 17:40:11
 * @LastEditors:  
 */

import 'package:flutter/material.dart';
import './baseModel.dart';

class MYPCollectionListModel extends MYPModel {
  String name;
  String desc;
  String icon;
  IconData iconData;

  MYPCollectionListModel({this.name, this.desc, this.icon, this.iconData});

  MYPCollectionListModel.fromJson(Map<String, dynamic> json) {
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