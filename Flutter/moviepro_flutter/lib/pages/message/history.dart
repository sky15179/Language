/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-05-15 11:06:57
 * @LastEditTime: 2020-05-15 11:25:59
 * @LastEditors:  
 */

import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import '../../model/homeList.dart';
import 'dart:convert' show json;
import 'package:dio/dio.dart';
import '../../event/user_login_event.dart';

Dio dio = new Dio();
const url = "http://api.maoyan.com/celebrity/follow/followingList";

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ApplicationEvent.event.fire(UserLoginEvent(User("123", 123)));
    addProxy();
    return content3(context);
  }

  void getHttp() async {
    try {
      Response response = await dio.get(url);
      // print(response);
    } catch (e) {
      print(e);
    }
  }

  Widget content3(BuildContext context) {
    getHttp();
    return FutureBuilder(
        future: dio.get(url),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String jsonStr = snapshot.data.toString();
            Map<String, dynamic> rootMap = json.decode(jsonStr);
            var root = new Root.fromJson(rootMap);
            return _ListView(models: root.data.dataList);
          } else {
            return Center(
              //loading状态
              child: Text("无数据"),
            );
          }
        });
  }

  addProxy() {
    var client = (dio.httpClientAdapter as DefaultHttpClientAdapter);
    client.onHttpClientCreate = (client) {
      client.findProxy = (url) {
        ///设置代理 电脑ip地址
        ///172.19.160.227
        return "PROXY 172.19.160.227:8888";

        ///不设置代理
//          return 'DIRECT';
      };

      // ///忽略证书
      // client.badCertificateCallback =
      //     (X509Certificate cert, String host, int port) => true;
    };
  }

  Widget content2(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString("lib/data/fake/list.json"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String jsonStr = snapshot.data.toString();
            Map<String, dynamic> rootMap = json.decode(jsonStr);
            var root = new Root.fromJson(rootMap);
            return _ListView(models: root.data.dataList);
          } else {
            return Center(
              //loading状态
              child: Text("无数据"),
            );
          }
        });
  }
}

class _ListView extends StatelessWidget {
  final List<DataList> models;

  const _ListView({Key key, this.models}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //下划线widget预定义以供复用。
    Widget divider1 = Divider(
      color: Colors.blue,
    );
    Widget divider2 = Divider(color: Colors.green);
    return ListView.separated(
      itemCount: models.length,
      //列表项构造器
      itemBuilder: (BuildContext context, int index) {
        var title = models[index].publisherBody;
        if (title == null) {
          title = "默认";
        }
        return ListTile(title: Text(title));
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
    );
  }
}
