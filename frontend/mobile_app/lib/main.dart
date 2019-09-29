import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
import 'repo/repo.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

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
  final _messaging = FirebaseMessaging();

  String postUrl(int page) {
    var baseUrl = 'http://84590504.ngrok.io/api/post/';
    if (filter == FilterEnum.hotPosts) {
      baseUrl += 'popular/';
    }
    return baseUrl;
  }
  
  Future<dynamic> _onMessage(Map<String, dynamic> payload) async {
    final data = payload['data'] ?? payload;
    final post = PostModel.fromJson(json.decode(data['post']));
    _listController.dispatch(PaginatedListAdd<PostModel>(value: post));
  }

  @override
  void initState() {
    _messaging.configure(onMessage: _onMessage);
    
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
      floatingActionButton: _filterWidget(),
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

  Widget _filterWidget() {
    return SpeedDial(
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      closeManually: false,
      curve: Curves.bounceIn,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            child: Icon(Icons.whatshot),
            backgroundColor: Colors.red,
            label: 'HOT POSTS',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                filter = FilterEnum.hotPosts;
                _listController.dispatch(PaginatedListRefresh());
              });
            }
        ),
        SpeedDialChild(
          child: Icon(Icons.fiber_new),
          backgroundColor: Colors.blue,
          label: 'NEW POSTS',
          labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                filter = FilterEnum.newPosts;
                _listController.dispatch(PaginatedListRefresh());
              });
            }
        ),
      ],
    );
  }

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
