import 'package:hive/hive.dart';

part 'image_download_info.g.dart';


@HiveType(typeId: 1)
class ImageDownloadInfo extends HiveObject {
  ImageDownloadInfo(
      {required this.pageCount,
      required this.fileName,
      required this.illustId,
      required this.imageUrl});

  @HiveField(0)
  late int id;

  @HiveField(1)
  final String fileName;

  @HiveField(2)
  final int illustId;

  @HiveField(3)
  final int pageCount;

  @HiveField(4)
  final String imageUrl;

  late int downloadPercent;


  void updateDownloadPercent(received, total) {
    downloadPercent=received/total;
  }
}
