// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'illust.dart';

part 'artist.g.dart';

@JsonSerializable()
//带有三张图片的画师
class Artist {
  int? id;
  String? name;
  String? account;
  String? avatar;
  String? comment;
  String? gender;
  String? birthDay;
  String? region;
  String? webPage;
  String? twitterAccount;
  String? twitterUrl;
  String? totalFollowUsers;
  String? totalIllustBookmarksPublic;
  var isFollowed;
  List<Illust>? recentlyIllustrations;

  Artist(
      { this.id,
       this.name,
       this.account,
       this.avatar,
       this.comment,
       this.gender,
       this.birthDay,
       this.region,
       this.webPage,
       this.twitterAccount,
       this.twitterUrl,
       this.totalFollowUsers,
       this.totalIllustBookmarksPublic,
      this.isFollowed,
       this.recentlyIllustrations});

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}

@JsonSerializable()
class ArtistPreView {
  int? id;
  String name;
  String? account;
  String avatar;
  bool? isFollowed;

  ArtistPreView(
      {required this.id,
      required this.name,
      this.account,
      required this.avatar,
      this.isFollowed});

  factory ArtistPreView.fromJson(Map<String, dynamic> json) =>
      _$ArtistPreViewFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistPreViewToJson(this);
}


@JsonSerializable()
class ImageUrls {
  String squareMedium;
  String medium;
  String large;
  String original;

  ImageUrls(
      {required this.squareMedium,
      required this.medium,
      required this.large,
      required this.original});

  factory ImageUrls.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUrlsToJson(this);
}

@JsonSerializable()
class ArtistSummary {
  int illustSum;
  int mangaSum;

  ArtistSummary({required this.illustSum, required this.mangaSum});

  factory ArtistSummary.fromJson(Map<String, dynamic> json) =>
      _$ArtistSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ArtistSummaryToJson(this);
}
