/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-04-24 16:35:05
 * @LastEditTime: 2020-05-28 11:24:29
 * @LastEditors:  
 */
import 'package:flutter/material.dart';
import 'package:moviepro_flutter/pages/message/history.dart';
import './list.dart';
import './test.dart';
import '../event/user_login_event.dart';
import './message/index.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MessagePage extends StatefulWidget {
  final int currentSelected;

  MessagePage({Key key, @required this.currentSelected}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  int _currentSelected;
  final List tabs = ["新闻", "历史", "图片", "测试"];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentSelected = widget.currentSelected;
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ApplicationEvent.event.fire(UserLoginEvent(User("333", 333)));
    return Column(
      children: <Widget>[
        Container(
          color: Colors.red,
          child: TabBar(
              //生成Tab菜单
              controller: _tabController,
              onTap: _onTap,
              tabs: tabs.map((e) => Tab(text: e)).toList()),
        ),
        Flexible(
          child: IndexedStack(
            index: _currentSelected,
            children: <Widget>[
              MYPListView(),
              _histroyPage(),
              GridView(),
              Text('测试'),
              Text('没有'),
            ],
          ),
        ),
      ],
    );
  }

  _onTap(int index) {
    setState(() {
      _currentSelected = _tabController.index;
    });
  }

  Widget _currentPage(int index) {
    switch (index) {
      case 0:
        return MYPListView();
      // return ListView3();
      case 1:
        return _histroyPage();
      case 2:
        return Text('图片');
      case 3:
        return Text('测试');
      default:
        return Text('没有');
    }
  }

  Widget _histroyPage() {
    return HistoryPage();
  }
}


class GridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) => new Container(
          color: Colors.green,
          child: new Center(
            child: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text('$index'),
            ),
          )),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
