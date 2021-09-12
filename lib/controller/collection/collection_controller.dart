// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class CollectionController extends GetxController
    with StateMixin<List<Collection>> {
  late int currentViewerPage;
  late int userId;

  final collectionList = Rx<List<Collection>>([]);
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();
  static CollectionRepository collectionRepository =
      getIt<CollectionRepository>();

  Future<List<Collection>> getCollectionList({currentViewerPage = 1}) async {
    return await userRepository.queryViewUserCollection(
        userId, currentViewerPage, 10);
  }

  void updateTitle(String title, List<TagList> tagList, int index) {
    collectionList.value[index].title = title;
    collectionList.value[index].tagList = tagList;
    update(['collectionTitle']);
  }

  void refreshList() {
    getCollectionList().then((value) {
      if (value.isNotEmpty) {
        collectionList.value = value;
        change(collectionList.value, status: RxStatus.success());
      } else
        change(collectionList.value, status: RxStatus.empty());
    });
  }


  @override
  void onInit() {
    userId = userService.userInfo()!.id;
    getCollectionList().then((value) {
      if (value.isNotEmpty) {
        collectionList.value = value;
        change(collectionList.value, status: RxStatus.success());
      } else
        change(collectionList.value, status: RxStatus.empty());
      // return collectionList.value = value;
    });
    super.onInit();
  }
}
