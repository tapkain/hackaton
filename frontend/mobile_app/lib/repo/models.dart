class VoteModel {
  static int deepLike = 20;

  int id;
  String userId;
  int postId;
  int vote;

  VoteModel({
    this.id,
    this.userId,
    this.postId,
    this.vote,
  });

  VoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    vote = json['vote'] ?? 10;
  }
}

enum ContentType { image, video }

class ContentModel {
  String userId;
  String hash;
  String mime;

  ContentType get type {
    if (mime == null) {
      return ContentType.image;
    }

    final descriptor = mime.split('/').first;
    if (descriptor == 'video') {
      return ContentType.video;
    }
    if (descriptor == 'image') {
      return ContentType.image;
    }
    return ContentType.image;
  }

  ContentModel({
    this.userId,
    this.hash,
    this.mime,
  });

  ContentModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    hash = json['hash'];
    mime = json['mime'];
  }
}

class PostModel {
  int id;
  int parentPostId;
  String userId;
  List<ContentModel> contents;
  String description;

  PostModel({
    this.id,
    this.userId,
    this.description,
    this.parentPostId,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentPostId = json['parent_post_id'];
    userId = json['user_id'];
    contents = new List<ContentModel>();
    if (json['contents'] != null) {
      json['contents'].forEach((v) {
        contents.add(new ContentModel.fromJson(v));
      });
    }
  }
}
