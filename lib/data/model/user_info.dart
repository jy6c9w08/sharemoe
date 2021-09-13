// Package imports:
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class UserInfo {
  @HiveField(0)
  int id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String email;
  @HiveField(3)
  String avatar;
  @HiveField(4)
  var gender;
  @HiveField(5)
  var signature;
  @HiveField(6)
  var location;
  @HiveField(7)
  int permissionLevel;
  @HiveField(8)
  int? isBan;
  @HiveField(9)
  int? star;
  @HiveField(10)
  bool isCheckEmail;
  @HiveField(11)
  String createDate;
  @HiveField(12)
  String updateDate;
  @HiveField(13)
  String? permissionLevelExpireDate;
  @HiveField(14)
  bool isBindQQ;
  @HiveField(15)
  String? ageForVerify;
  @HiveField(16)
  String? phone;

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
      required this.isBindQQ,
      this.ageForVerify,this.phone});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  @override
  String toString() {
    return 'UserInfo{id: $id, username: $username, email: $email, avatar: $avatar, gender: $gender, signature: $signature, location: $location, permissionLevel: $permissionLevel, isBan: $isBan, star: $star, isCheckEmail: $isCheckEmail, createDate: $createDate, updateDate: $updateDate, permissionLevelExpireDate: $permissionLevelExpireDate, isBindQQ: $isBindQQ}';
  }
}
