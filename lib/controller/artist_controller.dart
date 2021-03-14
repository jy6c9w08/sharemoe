import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class ArtistController extends GetxController {

  final artistList=Rx<List<Artist>>();

  int currentPage;

  void onInit() {
    getArtistListData().then((value) => artistList.value=value);
    super.onInit();
  }


  getArtistData() {}

  Future<List<Artist>> getArtistListData({currentPage = 1}) async {
    return await getIt<UserRepository>()
        .queryFollowedWithRecentlyIllusts(picBox.get('id'), currentPage, 30);
  }
}
