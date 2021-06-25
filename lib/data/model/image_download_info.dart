import 'package:hive/hive.dart';
import 'package:sharemoe/basic/config/hive_config.dart';

part 'image_download_info.g.dart';

@HiveType(typeId: 2)
enum DownloadState {
  //下载中
@HiveField(0)
  downloading,
  //下载完成
@HiveField(1)
  completed,
  //下载失败
@HiveField(2)
  failed
}
@HiveType(typeId: 1)
class ImageDownloadInfo extends HiveObject {
  ImageDownloadInfo(
      {required this.fileName,
      required this.illustId,
      required this.downloadState,
      required this.imageUrl});

  @HiveField(0)
  final String fileName;

  @HiveField(1)
  final int illustId;

  @HiveField(2)
  DownloadState downloadState;

  @HiveField(3)
  final String imageUrl;
}
