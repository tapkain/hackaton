import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'data explorer',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum FilterEnum {
  newPosts,
  hotPosts,
}

class _MyHomePageState extends State<MyHomePage> {
  PaginatedListController<int> _listController;
  var filter = FilterEnum.newPosts;

  @override
  void initState() {
    _listController = PaginatedListController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildList() {
    if (_listController == null) {
      return Container();
    }

    return PaginatedList(
      builder: _buildListItem,
      controller: _listController,
    );
  }

  Widget _filterWidget() {}

  Widget _buildListItem(BuildContext context, int item) {

  }
}
