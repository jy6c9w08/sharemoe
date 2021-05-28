import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  int id;
  String username;
  String email;
  String avatar;
  var gender;
  var signature;
  var location;
  int permissionLevel;
  int isBan;
  int star;
  bool isCheckEmail;
  String createDate;
  String updateDate;
  var permissionLevelExpireDate;
  bool isBindQQ;

  UserInfo(
      {required this.id,
        required this.username,
        required this.email,
        required this.avatar,
        this.gender,
        this.signature,
        this.location,
        required this.permissionLevel,
        required this.isBan,
        required this.star,
        required this.isCheckEmail,
        required this.createDate,
        required this.updateDate,
        this.permissionLevelExpireDate,
        required this.isBindQQ});

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
