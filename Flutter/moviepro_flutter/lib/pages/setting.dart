import 'package:flutter/material.dart';
import './test.dart';
import './collection.dart';
import '../model/collectionModel.dart';
import './settingChart.dart';
import './pie_chart/pie_chart_page.dart';
// import 'package:flutter_boost/flutter_boost.dart';

class SettingPage extends StatelessWidget {
  final List<MYPCollectionListModel> modes = [
      MYPCollectionListModel(name: "测试1", iconData: Icons.ac_unit),
      MYPCollectionListModel(name: "测试2", iconData: Icons.airport_shuttle),
      MYPCollectionListModel(
          name: "测试3", iconData: Icons.beach_access),
      MYPCollectionListModel(name: "测试4", iconData: Icons.cake),
    ];

  @override
  Widget build(BuildContext context) {
    return PieChartPage();
  }

  Widget content() {
    return CollectionView(datas: modes);
  }
}

class FlexLayoutTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView3();
  }

  Widget content() {
    return Column(
      children: <Widget>[
        //Flex的两个子widget按1：2来占据水平空间
        Row(
          // direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              // flex: 1,
              children: <Widget>[
                Container(
                  height: 30.0,
                  color: Colors.red,
                  child: Text('123'),
                ),
              ],
              // child: Container(
              //   height: 30.0,
              //   color: Colors.red,
              // ),
            ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                    height: 50.0,
                    color: Colors.green,
                    child: Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: <Widget>[
                        Text('123'),
                        Text(
                          '11111111111111111111111111111111111111111111111111111111111111111',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: 200.0,
            //Flex的三个子widget，在垂直方向按2：1：1来占用100像素的空间
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 30.0,
                    color: Colors.red,
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 30.0,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Spacer extends StatelessWidget {
  const Spacer({Key key, this.flex = 1})
      : assert(flex != null),
        assert(flex > 0),
        super(key: key);

  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: const SizedBox.shrink(),
    );
  }
}
