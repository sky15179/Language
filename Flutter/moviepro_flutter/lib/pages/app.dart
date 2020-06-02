import 'package:flutter/material.dart';
import './index.dart';
import 'package:flutter/rendering.dart';

class AppComponent extends StatefulWidget {
  @override
  State createState() {
    return AppComponentState();
  }
}

class AppComponentState extends State<AppComponent> {
  AppComponentState() {

  }

  @override
  Widget build(BuildContext context) {
    // debugPaintSizeEnabled = true;
    final app = MaterialApp(
      title: 'Fluro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: HomePage(title: "测试"),
      routes: {
        "new_page": (context) => NewRoute(),
        "/": (context) => RootPage(),
        "tips2": (context) =>  TipRoute(text: ModalRoute.of(context).settings.arguments),
      },
    );
//    print("initial route = ${app.initialRoute}");
    return app;
  }
}