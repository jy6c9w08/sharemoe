// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/sharemoe_theme_util.dart';
import 'package:sharemoe/controller/collection/collection_detail_controller.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/home_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/controller/search_controller.dart' as SharemoeSearch;
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/collection/collection_selector_bar.dart';
import 'package:sharemoe/ui/page/pic/home_bottom_sheet.dart';

class SappBar extends GetView<SappBarController>
    implements PreferredSizeWidget {
  final ScreenUtil screen = ScreenUtil();
  final String? title;
  final String model;

  @override
  final String tag;

  SappBar({
    this.title,
    required this.model,
    required this.tag,
  });

  SappBar.home({this.title, this.model = 'home', this.tag = 'home'}) : super();

  SappBar.search({this.title, this.model = 'search', required this.tag})
      : super();

  SappBar.collection(
      {this.title, this.model = 'collection', this.tag = 'collection'})
      : super();

  SappBar.normal({this.title, this.model = 'normal', this.tag = 'normal'})
      : super();

  @override
  Size get preferredSize => Size.fromHeight(screen.setHeight(77));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: GetBuilder<SappBarController>(
            // init: Get.put(SappBarController(), tag: tag),
            init: SappBarController(),
            tag: tag,
            builder: (_) {
              return CustomScrollView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: chooseAppBar(),
                  ),
                  GetBuilder<CollectionSelectorCollector>(builder: (_) {
                    return CollectionSelectionBar();
                  }),
                ],
              );
            }));
  }

  Widget chooseAppBar() {
    switch (model) {
      case 'home':
        return homeAppBar();
      case 'normal':
        return defaultAppBar();
      case 'search':
        return searchAppbar();
      case 'collection':
        return collectionAppbar();
      default:
        return homeAppBar();
    }
  }

  Widget homeAppBar() {
    return GetX<SappBarController>(
        tag: tag,
        builder: (_) {
          return Container(
              height: screen.setHeight(35),
              padding: EdgeInsets.symmetric(horizontal: screen.setWidth(7)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icon/search.svg',
                        width: screen.setWidth(20),
                        height: screen.setWidth(20),
                      ),
                      onPressed: () {
                        getIt<UserService>().isLogin()
                            ? Get.toNamed(Routes.SEARCH,
                                arguments: 'searchdefault')
                            : Get.find<HomePageController>()
                                .pageController
                                .animateToPage(4,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut);
                      },
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.bottomSheet(HomeBottomSheet(),
                          backgroundColor: Theme.of(Get.context!)
                              .bottomSheetTheme
                              .backgroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(_.title.value,
                          style: TextStyle(
                              fontSize: 14,
                              // color: Color(0xFF515151),
                              color: Colors.orange[400],
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: IconButton(
                      onPressed: controller.selectDate,
                      icon: SvgPicture.asset(
                        'assets/icon/calendar_appbar.svg',
                        width: screen.setWidth(20),
                        height: screen.setWidth(20),
                      ),
                      iconSize: screen.setWidth(24),
                    ),
                  )
                ],
              ));
        });
  }

  Widget defaultAppBar() {
    return Container(
        height: screen.setHeight(35),
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(18), right: ScreenUtil().setWidth(18)),
        child: Text(title!,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700)));
  }

  Widget searchAppbar() {
    return GetX<SappBarController>(
        tag: tag,
        initState: (state) {
          if (tag != 'searchdefault')
            controller.searchTextEditingController.text = tag.substring(6);
        },
        builder: (controller) {
          print(tag);
          return AnimatedContainer(
              duration: Duration(milliseconds: 250),
              curve: Curves.easeInOutExpo,
              height: controller.searchBarHeight.value,
              child: ListView(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(8),
                ),
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          constraints:
                              BoxConstraints(minWidth: 100.w, maxWidth: 266.w),
                          // width: ScreenUtil().setWidth(266),
                          height: ScreenUtil().setHeight(25),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(Get.context!)
                                .extension<CustomColors>()!
                                .inputBarBackgroundColor,
                          ),
                          child: TextField(
                            controller: controller.searchTextEditingController,
                            focusNode: controller.searchFocusNode,
                            onSubmitted: (value) {
                              SharemoeSearch.SearchController searchController =
                                  Get.find<SharemoeSearch.SearchController>(
                                      tag: tag);

                              searchController.searchKeywords =
                                  controller.searchTextEditingController.text;
                              if (!searchController.currentOnLoading.value) {
                                Get.find<WaterFlowController>(tag: tag)
                                  ..model = 'searchByTitle'
                                  ..refreshIllustList(
                                      searchKeyword: controller
                                          .searchTextEditingController.text,
                                      tag: tag);
                              }
                              Get.put(
                                  WaterFlowController(
                                      model: 'searchByTitle',
                                      searchKeyword: controller
                                          .searchTextEditingController.text),
                                  tag: tag);
                              searchController.currentOnLoading.value = false;
                              searchController.getSuggestionList();
                            },
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '要搜点什么呢',
                              contentPadding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(8),
                                  bottom: ScreenUtil().setHeight(9)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: IconButton(
                          onPressed: () async {
                            if (/*Get.find<GlobalController>().isLogin.value*/ getIt<
                                    UserService>()
                                .isLogin()) {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.image);
                              if (result != null)
                                Get.find<SharemoeSearch.SearchController>(
                                        tag: tag)
                                    .searchSimilarPicture(
                                        File(result.files.first.path!), tag);
                              else
                                BotToast.showSimpleNotification(
                                    title: TextZhPappBar.noImageSelected,
                                    hideCloseButton: true);
                            }
                          },
                          icon: SvgPicture.asset(
                            'assets/icon/camera.svg',
                            width: 24.w,
                            height: 24.w,
                          ),
                        ),
                      ),
                      if (!Get.find<SharemoeSearch.SearchController>(tag: tag)
                          .currentOnLoading
                          .value)
                        IconButton(
                          onPressed: () {
                            Get.dialog(AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.h),
                                content: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    width: 260.w,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            minVerticalPadding: 0,
                                            title: Text("画作类型",
                                                style:
                                                    TextStyle(fontSize: 16.sp)),
                                            subtitle:
                                                GetBuilder<SappBarController>(
                                                    tag: tag,
                                                    id: 'switchImageType',
                                                    builder: (_) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          checkBox(
                                                              "插画",
                                                              _.selectIllustType,
                                                              _.switchIllustType),
                                                          checkBox(
                                                              "漫画",
                                                              _.selectMagaType,
                                                              _.switchMagaType)
                                                        ],
                                                      );
                                                    }),
                                          ),
                                          ListTile(
                                            title: Text("搜索类型",
                                                style:
                                                    TextStyle(fontSize: 16.sp)),
                                            subtitle:
                                                GetBuilder<SappBarController>(
                                                    tag: tag,
                                                    id: 'switchSearchType',
                                                    builder: (_) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          checkBox(
                                                              "原始",
                                                              _.searchOriginalType,
                                                              _.switchOriginalType),
                                                          checkBox(
                                                              "自动翻译",
                                                              _.searchTranslateType,
                                                              _.switchTranslateType),
                                                        ],
                                                      );
                                                    }),
                                          ),
                                          GetBuilder<SappBarController>(
                                              tag: tag,
                                              id: 'updateData',
                                              builder: (controller) {
                                                return ListTile(
                                                  minVerticalPadding: 0,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 16.w,
                                                          vertical: 5.h),
                                                  title: Text("发布时间",
                                                      style: TextStyle(
                                                          fontSize: 16.sp)),
                                                  subtitle: Text(controller
                                                              .dateStart ==
                                                          null
                                                      ? "选择日期"
                                                      : "${controller.dateStart}--${controller.dateEnd}"),
                                                  onTap: controller
                                                      .selectRangeDate,
                                                );
                                              }),
                                          ListTile(
                                            title: Text("最小宽度",
                                                style:
                                                    TextStyle(fontSize: 16.sp)),
                                            subtitle: TextField(
                                                controller: controller
                                                    .minWidthTextController),
                                          ),
                                          ListTile(
                                            title: Text("最小高度",
                                                style:
                                                    TextStyle(fontSize: 16.sp)),
                                            subtitle: TextField(
                                                controller: controller
                                                    .minHeightTextController),
                                          ),
                                          ElevatedButton(
                                              onPressed: () => controller
                                                  .searchByCriteriaButton(tag),
                                              child: Text("按这个条件搜索"))
                                        ],
                                      ),
                                    ),
                                  ),
                                )));
                          },
                          icon: SvgPicture.asset(
                            'assets/icon/setting.svg',
                            width: 20.w,
                            height: 20.w,
                          ),
                        )
                    ],
                  ),
                  controller.searchBarHeight.value == screen.setHeight(45)
                      ? Container()
                      : searchAdditionGroup()
                ],
              ));
        });
  }

  Widget checkBox(String title, bool value, Function onChange) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 13.sp)),
        Checkbox(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.w)),
          value: value,
          onChanged: (value) => onChange(value),
        )
      ],
    );
  }

  Widget searchAdditionGroup() {
    return Container(
      width: ScreenUtil().setWidth(285),
      height: 35.h,
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          searchAdditionCell(TextZhPappBar.transAndSearch,
              onTap: () => controller.searchByTranslation(tag)),
          searchAdditionCell(TextZhPappBar.idToArtist,
              onTap: () => controller.searchArtistById(tag)),
          searchAdditionCell(TextZhPappBar.idToIllust,
              onTap: () => controller.searchIllustById(tag)),
        ],
      ),
    );
  }

  Widget searchAdditionCell(String label, {required Function onTap}) {
    return GetBuilder<SappBarController>(
        tag: tag,
        builder: (_) {
          return Container(
            width: 90.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                if (_.searchTextEditingController.text != '') {
                  onTap();
                } else {
                  BotToast.showSimpleNotification(
                      title: TextZhPappBar.inputError, hideCloseButton: true);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    label,
                    style: Theme.of(Get.context!).primaryTextTheme.labelLarge,
                  ),
                  if (label == TextZhPappBar.transAndSearch)
                    SvgPicture.asset(
                      'assets/icon/VIP_avatar.svg',
                      height: 15.h,
                    ),
                ],
              ),
            ),
          );
        });
  }

  Widget collectionAppbar() {
    return Container(
      height: screen.setHeight(35),
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(18), right: ScreenUtil().setWidth(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: screen.setHeight(35),
            alignment: Alignment.center,
            // padding: EdgeInsets.only(left: 5, right: 5),
            child: GetBuilder<CollectionDetailController>(
                id: 'title',
                builder: (_) {
                  return Text(_.collection.title,
                      style: TextStyle(
                          fontSize: 14,
                          // color: Color(0xFF515151),
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w700));
                }),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.COLLECTION_CREATE_PUT);
              // Get.find<CollectionSelectorCollector>()
              //     .showCollectionInfoEditDialog();
            },
            child: Container(
              height: screen.setHeight(35),
              alignment: Alignment.center,
              // padding: EdgeInsets.only(left: 8),
              child: FaIcon(
                FontAwesomeIcons.cog,
                color: Color(0xFF515151),
                size: ScreenUtil().setWidth(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
