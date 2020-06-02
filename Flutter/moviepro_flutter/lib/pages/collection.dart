import 'package:flutter/material.dart';
import '../model/collectionModel.dart';

abstract class DataDelegate {
  const DataDelegate(this.refresh, this.more);
  final ValueChanged<void> refresh;
  final ValueChanged<void> more;
}

class CollectionViewDelegate extends DataDelegate {
  CollectionViewDelegate(refresh, more) : super(refresh, more);
}

class CollectionView extends StatefulWidget {
  CollectionView({
    Key key,
    @required this.datas,
  }) : super(key: key);

  final List<dynamic> datas;

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<CollectionView> {
  List<dynamic> _datas;

  @override
  void initState() {
    super.initState();
    _datas = widget.datas;
  }

  @override
  Widget build(BuildContext context) {
    return content();
  }

  Widget content() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
        ),
        itemCount: _datas.length,
        itemBuilder: (context, index) {
          if (index == _datas.length - 1 && index < 50) {
            _needMore();
          }
          return CollectionViewHomeCell(data: _datas[index]);
        });
  }

  //模拟异步获取数据
  void _needMore() {
    Future.delayed(Duration(milliseconds: 20)).then((e) {
      setState(() {
        var moreDatas = [
          MYPCollectionListModel(name: "测试1", iconData: Icons.ac_unit),
          MYPCollectionListModel(name: "测试2", iconData: Icons.airport_shuttle),
          MYPCollectionListModel(name: "测试3", iconData: Icons.beach_access),
          MYPCollectionListModel(name: "测试4", iconData: Icons.cake),
        ];
        for (var item in moreDatas) {
          _datas.add(item);
        }
      });
    });
  }
}

class StaticCollectionView extends StatelessWidget {
  StaticCollectionView({
    Key key,
    @required this.datas,
  }) : super(key: key);

  final List<dynamic> datas;

  @override
  Widget build(BuildContext context) {
    return content();
  }

  Widget content() {
    List<CollectionViewHomeCell> cells = datas.map((e) {
      if (e is MYPCollectionListModel) {
        return CollectionViewHomeCell(data: e);
      } else {
        return null;
      }
    }).toList();
    cells.removeWhere((v) => v == null);
    return GridView.extent(
      maxCrossAxisExtent: 200.0,
      childAspectRatio: 2.0,
      children: cells,
    );
  }
}

class CollectionViewHomeCell extends StatelessWidget {
  final MYPCollectionListModel data;

  const CollectionViewHomeCell({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[Icon(data.iconData), Text(data.name)],
    );
  }
}
