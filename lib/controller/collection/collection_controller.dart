import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class CollectionController extends GetxController {
  late int currentViewerPage;
  int userId = picBox.get('id');
 late Rx<List<Collection>> collectionList;

  Future<List<Collection>> getCollectionList({currentViewerPage = 1}) async {
    return await getIt<UserRepository>()
        .queryViewUserCollection(userId, currentViewerPage, 10);
  }

  void updateTitle(String title, List<TagList> tagList, int index) {
    collectionList.value[index].title = title;
    collectionList.value[index].tagList = tagList;
    update(['collectionTitle']);
  }

  void refreshList() {
    getCollectionList().then((value) => collectionList.value = value);
  }

  @override
  void onInit() {
    print('init collection controller');
    getCollectionList().then((value) => collectionList.value = value);
    super.onInit();
  }
}
