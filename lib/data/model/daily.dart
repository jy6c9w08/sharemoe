// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:sharemoe/data/model/illust.dart';

part 'daily.g.dart';

@JsonSerializable()
class DailyModel {
  int? score;
  Sentence sentence;
  Illust illustration;

  DailyModel(
      {required this.sentence,
      required this.illustration,
      required this.score});

  factory DailyModel.fromJson(Map<String, dynamic> json) =>
      _$DailyModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyModelToJson(this);
}

@JsonSerializable()
class Sentence {
  int id;
  String content;
  String originateFrom;
  String? originateFromJP;
  String? author;

  Sentence(
      {required this.id,
      required this.content,
      required this.originateFrom,
      required this.author});

  factory Sentence.fromJson(Map<String, dynamic> json) =>
      _$SentenceFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceToJson(this);
}
