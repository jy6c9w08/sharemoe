// Package imports:
import 'package:hive/hive.dart';

part 'local_setting.g.dart';

@HiveType(typeId: 3)
class LocalSetting extends HiveObject {
  @HiveField(0)
  late bool isR16;

  LocalSetting({required this.isR16});
}
