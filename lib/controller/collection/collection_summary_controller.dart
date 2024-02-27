import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

import 'collection_selector_controller.dart';

class CollectionSummaryController extends GetxController
    with StateMixin<List<CollectionSummary>> {
  late int userId;
  late List<CollectionSummary> collectionSummary = [];
final CollectionSelectorCollector collectionSelectorCollector=Get.find<CollectionSelectorCollector>();
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();
  static CollectionRepository collectionRepository =
      getIt<CollectionRepository>();

  Future<List<CollectionSummary>> getCollectionsDigest() async {
    return await userRepository.queryGetOneselfCollectionSummary(userId);
  }
 void refreshCollectionsDigest(){
  getCollectionsDigest().then((value) {
    if (value.isNotEmpty) {
      collectionSummary = value;
      change(collectionSummary, status: RxStatus.success());
    } else
      change(collectionSummary, status: RxStatus.empty());
  });
}

  //添加画作到画集
  addIllustToCollection(int collectionId, {List<int>? illustList}) async {
    await collectionRepository
        .queryAddIllustToCollection(
        collectionId, illustList ?? collectionSelectorCollector.selectList.map((e) => e.id).toList())
        .then((value) {
      collectionSelectorCollector.clearSelectList();
      Get.back();
    });
  }


  @override
  void onInit() {
    userId = userService.userInfo()!.id;
    getCollectionsDigest().then((value) {
      if (value.isNotEmpty) {
        collectionSummary = value;
        change(collectionSummary, status: RxStatus.success());
      } else
        change(collectionSummary, status: RxStatus.empty());
    });
    super.onInit();
  }
}
