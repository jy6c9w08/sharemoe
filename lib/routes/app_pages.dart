// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/bindings/artist_binding.dart';
import 'package:sharemoe/bindings/collection_binding.dart';
import 'package:sharemoe/bindings/download_binding.dart';
import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/bindings/login_binding.dart';
import 'package:sharemoe/bindings/message_binding.dart';
import 'package:sharemoe/bindings/pic_binding.dart';
import 'package:sharemoe/bindings/pic_detail_binding.dart';
import 'package:sharemoe/bindings/search_binding.dart';
import 'package:sharemoe/bindings/type_binding.dart';
import 'package:sharemoe/bindings/user_setting_binding.dart';
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
import 'package:sharemoe/ui/page/user/sub_page/message/message_list_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/message/single_comment_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/setting_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/type_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/vip/vip_page.dart';
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
        name: Routes.DETAIL,
        page: () => PicDetailPage(
              tag: Get.arguments + getIt<UserService>().isLogin().toString()
                  as String,
            ),
        binding: PicDetailBinding()),
    GetPage(
        name: Routes.COMMENT,
        page: () => CommentPage(
              Get.arguments as String,
            )),
    //TODO 优化传参
    GetPage(
        name: Routes.COMMENT_REPLY,
        page: () => CommentPage.reply(
              Get.arguments[0],
              replyParentId: Get.arguments[1],
              replyToName: Get.arguments[2],
              replyToId: Get.arguments[3],
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
    GetPage(
        name: Routes.USER_SETTING,
        page: () => SettingPage(),
        binding: UserSettingBinding()),
    GetPage(
      name: Routes.USER_MESSAGE_TYPE,
      page: () => TypePage(),
      binding: TypeBinding()
    ),
    GetPage(
      name: Routes.USER_MESSAGE,
      page: () => MessageListPage(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: Routes.USER_SINGLE_COMMENT,
      page: () => SingleCommentPage(),
      binding: SingleCommentBinding(),
    ),
    GetPage(
      name: Routes.USER_THUMB,
      page: () => MessageListPage(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: Routes.USER_VIP,
      page: () =>VIPPage(),
    ),
  ];
}
