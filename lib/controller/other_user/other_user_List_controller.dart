import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';

class OtherUserListController extends GetxController {
  final Rx<List<BookmarkedUser>> otherUserList = Rx<List<BookmarkedUser>>([]);
final int illustId;

  OtherUserListController({required this.illustId});
 Future getUsersData() async {
    return await getIt<IllustRepository>()
        .queryUserOfCollectionIllustList(illustId, 1, 10);
  }

  @override
  void onInit() {
    getUsersData().then((value) =>otherUserList.value=value);
    super.onInit();
  }
}
