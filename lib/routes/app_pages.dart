import 'package:get/get.dart';
import 'package:sharemoe/bindings/artist_binding.dart';
import 'package:sharemoe/bindings/collection_binding.dart';
import 'package:sharemoe/bindings/download_binding.dart';

import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/bindings/login_binding.dart';
import 'package:sharemoe/bindings/pic_binding.dart';
import 'package:sharemoe/bindings/pic_detail_binding.dart';
import 'package:sharemoe/bindings/search_binding.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/ui/page/artist/artist_detail_page.dart';
import 'package:sharemoe/ui/page/artist/artist_list_page.dart';
import 'package:sharemoe/ui/page/collection/collection_detail_page.dart';
import 'package:sharemoe/ui/page/collection/collection_page.dart';
import 'package:sharemoe/ui/page/comment/comment_page.dart';
import 'package:sharemoe/ui/page/download/download_page.dart';
import 'package:sharemoe/ui/page/home_page.dart';
import 'package:sharemoe/ui/page/login/login_page.dart';
import 'package:sharemoe/ui/page/pic_detail/pic_detail_page.dart';
import 'package:sharemoe/ui/page/search/search_page.dart';
import 'package:sharemoe/ui/page/user/user_page.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
        name: Routes.SEARCH,
        page: () => SearchPage(),
        binding: SearchBinding()),
    GetPage(
        name: Routes.LOGIN, page: () => LoginPage(), binding: LoginBinding()),
    GetPage(
        name: Routes.DETAIL,
        page: () => PicDetailPage(
              tag: Get.arguments +Get.find<GlobalController>().isLogin.value.toString() as String,
            ),
        binding: PicDetailBinding()),
    GetPage(
        name: Routes.COMMENT,
        page: () => CommentPage(
              Get.arguments[0],
              illustId: Get.arguments[1],
              isReply: Get.arguments[2],
            )),
    GetPage(
        name: Routes.COMMENT_REPLY,
        page: () => CommentPage.reply(
              Get.arguments[0],
              illustId: Get.arguments[1],
              isReply: Get.arguments[2],
              replyParentId: Get.arguments[3],
              replyToName: Get.arguments[4],
              replyToId: Get.arguments[5],
            )),
    GetPage(
        name: Routes.BOOKMARK,
        page: () => TabView.bookmark(
            // firstView: '插画',
            // secondView: '漫画',
            ),
        binding: PicBinding()),
    GetPage(
        name: Routes.HISTORY,
        page: () => TabView.history(),
        binding: PicBinding()),
    GetPage(
        name: Routes.ARTIST_LIST,
        page: () => ArtistListPage(
              model: '',
            )),
    GetPage(name: Routes.USER, page: () => UserPage()),
    GetPage(
        name: Routes.ARTIST_DETAIL,
        page: () => ArtistDetailPage(
              tag: 'artist',
            ),
        binding: ArtistDetailBinding()),
    GetPage(
        name: Routes.COLLECTION,
        page: () => CollectionPage(),
        binding: CollectionBinding()),
    GetPage(
        name: Routes.COLLECTION_DETAIL,
        page: () => CollectionDetailPage(),
        binding: CollectionDetailBinding()),
    GetPage(
        name: Routes.DOWNLOAD,
        page: () => DownloadPage(),
        binding: DownloadBinding()),
  ];
}
