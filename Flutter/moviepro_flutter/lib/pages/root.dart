/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-04-24 16:49:48
 * @LastEditTime: 2020-05-27 19:32:03
 * @LastEditors:  
 */
import 'package:flutter/material.dart';
import 'package:moviepro_flutter/pages/index.dart';
import './test.dart';
import '../Utils/color.dart';
import 'package:event_bus/event_bus.dart';
import '../event/user_login_event.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  @override
  _MyRootPageState createState() => _MyRootPageState();
}

class _MyRootPageState extends State<RootPage> {
  int _selectedIndex = 0;
  String appBarTitle;

  List taData = [
    {'text': '首页', 'icon': Icon(Icons.home)},
    {'text': '信息', 'icon': Icon(Icons.business)},
    {'text': '我的', 'icon': Icon(Icons.school)},
  ];
  List<BottomNavigationBarItem> _myTabs = [];
  Widget _currentPage;

  @override
  void initState() {
    super.initState();
    ApplicationEvent.event = EventBus();
    appBarTitle = taData[_selectedIndex]['text'];
    _currentPage = _updateCurentPage(_selectedIndex);
    _myTabs = taData.map((e) {
      return BottomNavigationBarItem(icon: e['icon'], title: Text(e['text']));
    }).toList();
    ApplicationEvent.event.on<UserLoginEvent>().listen((event){
      print('登录用户：${event.user.name}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.mainTheme,
        title: Text(appBarTitle),
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                _onPress(context);
              }),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          HomePage(),
          MessagePage(currentSelected: 0),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: _myTabs,
        currentIndex: _selectedIndex,
        fixedColor: ColorsUtil.mainTheme,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "tips2", arguments: "hi");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: ColorsUtil.mainTheme,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      appBarTitle = taData[index]['text'];
      _currentPage = _updateCurentPage(index);
    });
  }

  Widget _updateCurentPage(int index) {
      switch (index) {
        case 0:
          return HomePage();
        case 1:
          return MessagePage(currentSelected: 0);
        case 2:
          return SettingPage();
        default:
          return null;
      }
  }

  void _onPress(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RouterTestRoute();
    }));
  }
}
