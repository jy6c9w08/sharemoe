import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class CollectionController extends GetxController {
  int currentViewerPage;
  int  userId = picBox.get('id');
  final collectionList = Rx<List<Collection>>();

  Future<List<Collection>> getCollectionList({currentViewerPage = 1}) async {
    return await getIt<UserRepository>()
        .queryViewUserCollection(userId, currentViewerPage, 10);
  }

  @override
  void onInit() {
    print('init collection controller');
    getCollectionList().then((value) => collectionList.value = value);
    super.onInit();
  }
}
