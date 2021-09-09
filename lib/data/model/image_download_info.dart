// Package imports:
import 'package:get/get.dart';
import 'package:hive/hive.dart';

part 'image_download_info.g.dart';

@HiveType(typeId: 1)
class ImageDownloadInfo extends HiveObject {
  ImageDownloadInfo(
      {required this.pageCount,
      //required this.fileName,
      required this.illustId,
      required this.imageUrl}) {
    this.fileName = this.imageUrl.substring(this.imageUrl.lastIndexOf("/") + 1);
  }

  @HiveField(0)
  late int id = 0;

  @HiveField(1)
  late String fileName;

  @HiveField(2)
  final int illustId;

  @HiveField(3)
  final int pageCount;

  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  late String filePath='';

  // late double downloadPercent;

  Rx<int> downloadPercent = Rx<int>(0);
  Rx<int?> fileTotal = Rx<int?>(null);

  void updateDownloadPercent(received, total) {
    if (total != -1) {
      fileTotal.value = total;
    }
    downloadPercent.value = received * 100;
  }
}
