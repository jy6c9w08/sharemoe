import 'package:hive/hive.dart';
import 'package:get/get.dart';

part 'image_download_info.g.dart';


@HiveType(typeId: 1)
class ImageDownloadInfo extends HiveObject {
  ImageDownloadInfo(
      {required this.pageCount,
      required this.fileName,
      required this.illustId,
      required this.imageUrl});

  @HiveField(0)
  late int id=0;

  @HiveField(1)
  late  String fileName;

  @HiveField(2)
  final int illustId;

  @HiveField(3)
  final int pageCount;

  @HiveField(4)
  final String imageUrl;

  // late double downloadPercent;

  Rx<double> downloadPercent=Rx<double>(0);


  void updateDownloadPercent(received, total) {
    downloadPercent.value=received/total;
  }
}
