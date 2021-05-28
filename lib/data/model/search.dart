import 'package:json_annotation/json_annotation.dart';

import 'illust.dart';


part 'search.g.dart';

@JsonSerializable()
class SearchKeywords {
  String keyword;
  String keywordTranslated;

  SearchKeywords({required this.keyword, required this.keywordTranslated});

  factory SearchKeywords.fromJson(Map<String, dynamic> json) =>
      _$SearchKeywordsFromJson(json);

  Map<String, dynamic> toJson() => _$SearchKeywordsToJson(this);
}

@JsonSerializable()
class HotSearch {
  String name;
  String translatedName;
  Illust illustration;
  HotSearch({required this.name, required this.translatedName,required this.illustration});

  factory HotSearch.fromJson(Map<String, dynamic> json) =>
      _$HotSearchFromJson(json);

  Map<String, dynamic> toJson() => _$HotSearchToJson(this);
}
