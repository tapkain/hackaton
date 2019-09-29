import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
import 'repo/repo.dart';

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
  PaginatedListController<PostModel> _listController;
  var filter = FilterEnum.newPosts;
  final api = WebApi();

  String postUrl(int page) {
    var baseUrl = 'http://84590504.ngrok.io/api/post/';
    return baseUrl;
  }

  @override
  void initState() {
    Future.microtask(() {
      _listController = PaginatedListController<PostModel>(
        fetchPage: (page, refresh) => api.post.fetchMany(postUrl(page)),
      );
      setState(() {});
    });
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

  Widget _buildListItem(BuildContext context, PostModel item) {
    final content = item.contents.first;
    final url = 'https://cdn.newlife.ai/${content.hash}';
    if (content.type == ContentType.image) {
      return ImageContentWidget(
        url: url,
      );
    }

    return VideoContentWidget(
      url: url,
    );
  }
}
