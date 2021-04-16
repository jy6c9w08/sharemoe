import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';

class CollectionDetailController extends GetxController {
  final collectionId;
  int currentPage;

  CollectionDetailController({this.collectionId});

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  // getCollectionIllust({int currentPage = 1}) {
  //   getIt<CollectionRepository>()
  //       .queryViewCollectionIllust(collectionId, currentPage, 10);
  // }
}
