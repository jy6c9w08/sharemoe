// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/bindings/artist_binding.dart';
import 'package:sharemoe/bindings/collection_binding.dart';
import 'package:sharemoe/bindings/comment_binding.dart';
import 'package:sharemoe/bindings/download_binding.dart';
import 'package:sharemoe/bindings/home_binding.dart';
import 'package:sharemoe/bindings/message_binding.dart';
import 'package:sharemoe/bindings/pic_binding.dart';
import 'package:sharemoe/bindings/pic_detail_binding.dart';
import 'package:sharemoe/bindings/search_binding.dart';
import 'package:sharemoe/bindings/type_binding.dart';
import 'package:sharemoe/bindings/user_mark_binding.dart';
import 'package:sharemoe/controller/comment/comment_text_filed_controller.dart';
import 'package:sharemoe/data/model/bookmarked_user.dart';
import 'package:sharemoe/ui/page/artist/artist_detail_page.dart';
import 'package:sharemoe/ui/page/artist/artist_list_page.dart';
import 'package:sharemoe/ui/page/center/create_put_collection_page.dart';
import 'package:sharemoe/ui/page/collection/collection_detail_page.dart';
import 'package:sharemoe/ui/page/collection/collection_page.dart';
import 'package:sharemoe/ui/page/comment/comment_page.dart';
import 'package:sharemoe/ui/page/download/download_page.dart';
import 'package:sharemoe/ui/page/home_page.dart';
import 'package:sharemoe/ui/page/other_user/other_user_follow_page.dart';
import 'package:sharemoe/ui/page/other_user/other_user_list_page.dart';
import 'package:sharemoe/ui/page/pic_detail/pic_detail_page.dart';
import 'package:sharemoe/ui/page/search/search_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/about/about_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/discussion/discussion_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/message/message_list_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/message/single_comment_page.dart';
import 'package:sharemoe/ui/page/user/sub_page/modify_info_page.dart';
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
        page: () => SearchPage(tag: Get.arguments),
        binding: SearchBinding()),
    GetPage(
        name: Routes.SEARCH_TAG,
        page: () => SearchPage(tag: Get.arguments),
        binding: SearchTagBinding()),
    GetPage(
        name: Routes.DETAIL,
        page: () => PicDetailPage(
            tag: Get.arguments + getIt<UserService>().isLogin().toString()
                as String),
        binding: PicDetailBinding()),
    GetPage(
        name: Routes.COMMENT,
        page: () => CommentPage(Get.arguments as String),
        binding: CommentBinding()),
    //TODO 优化传参
    GetPage(
        name: Routes.COMMENT_REPLY,
        page: () => CommentPage.reply(
              Get.arguments,
            )),
    GetPage(
        name: Routes.BOOKMARK,
        page: () => TabView.bookmark(
              userId: Get.arguments,
              title: '我的收藏',
              showAppbar: true,
            ),
        binding: UserMarkBinding()),
    GetPage(
        name: Routes.HISTORY,
        page: () => TabView.history(),
        binding: PicBinding()),
    GetPage(
        name: Routes.ARTIST_LIST, page: () => ArtistListPage(model: 'follow')),
    GetPage(name: Routes.USER, page: () => UserPage()),
    GetPage(
        name: Routes.ARTIST_DETAIL,
        page: () => ArtistDetailPage(
              tag: Get.arguments,
            ),
        binding: ArtistDetailBinding()),
    GetPage(
        name: Routes.COLLECTION_LIST,
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
    ),
    GetPage(
        name: Routes.USER_MESSAGE_TYPE,
        page: () => TypePage(),
        binding: TypeBinding()),
    GetPage(
      name: Routes.USER_MESSAGE,
      page: () => MessageListPage(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: Routes.USER_SINGLE_COMMENT,
      page: () => SingleCommentPage('single'),
      binding: SingleCommentBinding(),
    ),
    GetPage(
      name: Routes.USER_THUMB,
      page: () => MessageListPage(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: Routes.USER_VIP,
      page: () => VIPPage(),
    ),
    GetPage(
      name: Routes.OTHER_USER_LIST,
      page: () => OtherUserListPage(tag: Get.arguments),
    ),
    GetPage(
        name: Routes.OTHER_USER_FOLLOW,
        page: () =>
            OtherUserMarkPage(bookmarkedUser: Get.arguments as BookmarkedUser),
        binding: UserMarkBinding.other()),
    GetPage(
      name: Routes.MODIFY_INFO,
      page: () => ModifyInfoPage(),
    ),
    GetPage(
      name: Routes.ABOUT,
      page: () => AboutPage(),
    ),

    GetPage(
      name: Routes.DISCUSSION,
      page: () => DiscussionPage(),
    ),
    GetPage(
        name: Routes.COLLECTION_CREATE_PUT,
        page: () => CreateOrPutCollectionPage())
  ];
}
