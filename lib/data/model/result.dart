// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

@JsonSerializable(genericArgumentFactories: true,includeIfNull: true)
class Result<T> {
  String message;
  @JsonKey(defaultValue: null)
  T data;

  Result({required this.message, required this.data});

  factory Result.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ResultToJson(this, toJsonT);
}
