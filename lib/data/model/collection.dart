// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'collection.g.dart';

@JsonSerializable()
class Collection {
  int id;
  int userId;
  String username;
  List<Cover>? cover;
  String title;
  String caption;
  @JsonKey(defaultValue: [])
  List<TagList> tagList;
  int illustCount;
  var illustrationList;
  int isPublic;
  int useFlag;
  int forbidComment;
  int pornWarning;
  int totalBookmarked;
  int totalView;
  int totalPeopleSeen;
  int totalLiked;
  int totalReward;
  String createTime;

  Collection(
      {required this.id,
        required this.userId,
        required this.username,
         this.cover,
        required this.title,
        required this.caption,
        required this.tagList,
        required this.illustCount,
        this.illustrationList,
        required this.isPublic,
        required this.useFlag,
        required this.forbidComment,
        required this.pornWarning,
        required this.totalBookmarked,
        required this.totalView,
        required this.totalPeopleSeen,
        required this.totalLiked,
        required this.totalReward,
        required this.createTime});

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);
}

@JsonSerializable()
class Cover {
  String squareMedium;
  String medium;
  String large;
  String original;

  Cover({required this.squareMedium, required this.medium, required this.large, required this.original});

  factory Cover.fromJson(Map<String, dynamic> json) => _$CoverFromJson(json);

  Map<String, dynamic> toJson() => _$CoverToJson(this);
}

@JsonSerializable()
class TagList {
  int? id;
  String tagName;

  TagList({ this.id, required this.tagName});

  factory TagList.fromJson(Map<String, dynamic> json) =>
      _$TagListFromJson(json);

  Map<String, dynamic> toJson() => _$TagListToJson(this);
}
@JsonSerializable()
class CollectionSummary {
  int id;
  String title;

  CollectionSummary(this.title, this.id);

  factory CollectionSummary.fromJson(Map<String, dynamic> json) =>
      _$CollectionSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionSummaryToJson(this);
}
