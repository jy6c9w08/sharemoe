import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/repository/artist_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class ArtistListController extends GetxController {
  final artistList = Rx<List<Artist>>([]);
 final String model;
  late int currentPage;

  ArtistListController({required this.model});

  void onInit() {
    getArtistListData().then((value) => artistList.value = value);
    super.onInit();
  }



  Future<List<Artist>> getArtistListData({currentPage = 1}) async {
    switch (model) {
      case 'follow':
        return await getIt<UserRepository>().queryFollowedWithRecentlyIllusts(
            picBox.get('id'), currentPage, 30);
      case 'search':
        return await getIt<ArtistRepository>().querySearchArtist(
            Get.find<SearchController>().searchKeywords, currentPage, 30);
      default:
        return await getIt<UserRepository>().queryFollowedWithRecentlyIllusts(
            picBox.get('id'), currentPage, 30);
    }
  }
}
