import 'package:dio/dio.dart';
import 'dart:async';
import 'models.dart';
import 'resource.dart';

class WebApi {
  static final dio = Dio();

  final vote = Resource<VoteModel>(
    dio: dio,
    resourceName: 'votes',
    fromJson: (j) => VoteModel.fromJson(j),
  );

  final post = Resource<PostModel>(
    dio: dio,
    resourceName: 'posts',
    fromJson: (j) => PostModel.fromJson(j),
  );
}
