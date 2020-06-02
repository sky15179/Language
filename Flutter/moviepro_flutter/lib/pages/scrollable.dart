import 'package:flutter/material.dart';

class MyScrollView extends StatelessWidget {

  MyScrollView({
    Key key,
    @required this.str,
  }): super(key: key);

  final String str;
  
  @override
  Widget build(BuildContext context) {
  return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //动态创建一个List<Widget>
            children: str
                .split("")
                //每一个字母都用一个Text显示,字体为原来的两倍
                .map((c) => Text(
                      c,
                      textScaleFactor: 2.0,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}