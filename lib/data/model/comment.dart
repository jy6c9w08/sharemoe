// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  int id;
  String appType;
  int appId;
  int parentId;
  int replyFrom;
  String replyFromName;
  int replyTo;
  String? replyToName;
  String? platform;
  String content;
  String createDate;
  int likedCount;
  bool isLike;
  List<Comment>? subCommentList;

  Comment(
      {required this.id,
        required this.appType,
        required this.appId,
        required this.parentId,
        required this.replyFrom,
        required this.replyFromName,
        required this.replyTo,
        required this.replyToName,
        required this.platform,
        required this.content,
        required this.createDate,
        required this.likedCount,
        required this.isLike,
        required this.subCommentList});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
