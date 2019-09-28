class VoteModel {
  int vote;
  int voteId;
  String userId;
  String contentUrl;
  String contentType;

  VoteModel({
    this.vote,
    this.voteId,
    this.userId,
    this.contentType,
    this.contentUrl,
  });

  static VoteModel fromJson(Map<String, dynamic> json) {
    return VoteModel(
      vote: json['vote'],
      voteId: json['vote_id'],
      userId: json['user_id'],
      contentType: json['content_type'],
      contentUrl: json['content_url'],
    );
  }
}
