// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  int id;
  int type;
  List<Actors> actors;
  int actorCount;
  String objectType;
  int objectId;
  String objectTitle;
  int recipientId;
  String message;
  String? extend;
  String createDate;
  int status;

  Message(
      {required this.id,
      required this.type,
      required this.actors,
      required this.actorCount,
      required this.objectType,
      required this.objectId,
      required this.objectTitle,
      required this.recipientId,
      required this.message,
      required this.extend,
      required this.status,
      required this.createDate});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class Actors {
  int userId;
  String username;

  Actors({required this.userId, required this.username});

  factory Actors.fromJson(Map<String, dynamic> json) => _$ActorsFromJson(json);

  Map<String, dynamic> toJson() => _$ActorsToJson(this);
}
