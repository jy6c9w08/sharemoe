import 'package:json_annotation/json_annotation.dart';

import 'artist.dart';

part 'illust.g.dart';

@JsonSerializable()
class Illust {
  int id;
  double? artistId;
  String title;
  String type;
  String? caption;
  ArtistPreView artistPreView;
  List<Tags>? tags;
  List<ImageUrls> imageUrls;
  List<String> tools;
  DateTime createDate;
  int pageCount;
  double width;
  double height;
  int sanityLevel;
  double restrict;
  double totalView;
  double totalBookmarks;
  bool? isLiked;
  double xrestrict;
  // String link;
  // int adId;

  @override
  String toString() {
    return 'Illust{id: $id, artistId: $artistId, title: $title, type: $type, caption: $caption, artistPreView: $artistPreView, tags: $tags, imageUrls: $imageUrls, tools: $tools, createDate: $createDate, pageCount: $pageCount, width: $width, height: $height, sanityLevel: $sanityLevel, restrict: $restrict, totalView: $totalView, totalBookmarks: $totalBookmarks, xrestrict: $xrestrict}';
  }

  Illust(
      {required this.id,
       this.artistId,
      required this.title,
      required this.type,
      required this.caption,
      required this.artistPreView,
      required this.tags,
      required this.tools,
      required this.imageUrls,
      required this.createDate,
      required this.pageCount,
      required this.width,
      required this.height,
      required this.sanityLevel,
      required this.restrict,
      required this.totalView,
      required this.totalBookmarks,
       this.isLiked,
      required this.xrestrict,
});

  factory Illust.fromJson(Map<String, dynamic> json) => _$IllustFromJson(json);

  Map<String, dynamic> toJson() => _$IllustToJson(this);
}


@JsonSerializable()
class Tags {
  int? id;
  String name;
  String translatedName;

  Tags({ this.id, required this.name, required this.translatedName});

  factory Tags.fromJson(Map<String, dynamic> json) => _$TagsFromJson(json);

  Map<String, dynamic> toJson() => _$TagsToJson(this);
}

@JsonSerializable()
class ImageUrls {
  String squareMedium;
  String medium;
  String large;
  String original;

  ImageUrls({required this.squareMedium, required this.medium, required this.large, required this.original});

  factory ImageUrls.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUrlsToJson(this);
}
