import 'package:json_annotation/json_annotation.dart';

part 'verification.g.dart';

@JsonSerializable()
class Verification {
  String vid;
  String imageBase64;

  Verification({this.vid, this.imageBase64});

  factory Verification.fromJson(Map<String, dynamic> json) =>
      _$VerificationFromJson(json);

  Map<String, dynamic> toJson() => _$VerificationToJson(this);
}
