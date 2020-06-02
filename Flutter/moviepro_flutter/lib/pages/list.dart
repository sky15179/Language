import 'package:flutter/material.dart';
import '../model/baseModel.dart';

class MYPListView extends StatelessWidget {

  // @override
  // Widget build(BuildContext context) {
  //   List<MYPListModel> modes = [
  //     MYPListModel(name: "I\'m dedicating every day to you"),
  //     MYPListModel(name: "Domestic life was never quite my style"),
  //     MYPListModel(name: "When you smile, you knock me out, I fall ssss sssssss"),
  //     MYPListModel(name: "And I thought I was so smart"),
  //   ];
  //   List<Widget> cells = modes.map((e) {
  //     return MYPListCell(model: e);
  //   }).toList();
  //   return ListView(
  //     shrinkWrap: true,
  //     padding: const EdgeInsets.all(10.0),
  //     children: cells,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    List<MYPListModel> modes = [
      MYPListModel(name: "I\'m dedicating every day to you"),
      MYPListModel(name: "Domestic life was never quite my style"),
      MYPListModel(
          name: "When you smile, you knock me out, I fall ssss sssssss"),
      MYPListModel(name: "And I thought I was so smart"),
    ];
    Widget divider1 = Divider(
      color: Colors.blue,
    );
    Widget divider2 = Divider(color: Colors.green);
    return ListView.separated(
      itemCount: 100,
      //列表项构造器
      itemBuilder: (BuildContext context, int index) {
        return MYPListCell(model: modes[index % modes.length]);
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
    );
  }
}

class MYPListCell extends StatelessWidget {
  MYPListCell({
    Key key,
    @required this.model,
  }) : super(key: key);

  final MYPListModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      // direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          // flex: 1,
          children: <Widget>[
            Image(
              image: NetworkImage(
                  "http://p0.meituan.net/movie/5cbe849bb17c8966a423ee015dc21aca41689.jpg"),
              width: 50.0,
            ),
          ],
        ),
        Expanded(
            // flex: 2,
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Container(
              height: 50.0,
              color: Colors.green,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text('123'),
                  ),
                  Text(
                    this.model.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )),
        )),
      ],
    );
  }
}

class MYPListModel extends MYPModel {
  final String name;
  String desc;
  String icon;

  MYPListModel({this.name});
}
