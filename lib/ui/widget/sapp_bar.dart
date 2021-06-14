import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';

import 'package:sharemoe/basic/pic_texts.dart';
import 'package:sharemoe/controller/collection/collection_detail_controller.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/pic/home_bottom_sheet.dart';

class SappBar extends GetView<SappBarController>
    implements PreferredSizeWidget {
  final ScreenUtil screen = ScreenUtil();
  final String? title;
  final String model;
  final DateTime _picFirstDate = DateTime(2008, 1, 1);
  final DateTime _picLastDate = DateTime.now().subtract(Duration(hours: 39));

  final TextZhPappBar texts = TextZhPappBar();

  SappBar({this.title, required this.model});

  SappBar.home({this.title, this.model = 'home'}) : super();

  SappBar.search({this.title, this.model = 'search'}) : super();

  SappBar.collection({this.title, this.model = 'collection'}) : super();

  SappBar.normal({this.title, this.model = 'normal'}) : super();

  @override
  Size get preferredSize => Size.fromHeight(screen.setHeight(77));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: chooseAppBar(),
        ));
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
    return GetX<SappBarController>(builder: (_) {
      return Container(
          height: screen.setHeight(35),
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(18),
              right: ScreenUtil().setWidth(18)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.SEARCH);
                  },
                  child: Container(
                    height: screen.setHeight(35),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 8), //为点击时的效果而设置，无实际意义
                    child: FaIcon(
                      FontAwesomeIcons.search,
                      color: Color(0xFF515151),
                      size: ScreenUtil().setWidth(15),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(HomeBottomSheet(),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)));
                  },
                  child: Container(
                    height: screen.setHeight(35),
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
              ),
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () async {
                    WaterFlowController flowController =
                        Get.find<WaterFlowController>(tag: 'home');
                    DateTime? newDate = await showDatePicker(
                      context: Get.context!,
                      initialDate: flowController.picDate!,
                      firstDate: _picFirstDate,
                      lastDate: _picLastDate,
                      // locale: Locale('zh'),
                    );
                    if (newDate != null && flowController.picDate != newDate) {
                      flowController.refreshIllustList(picDate: newDate);
                    }
                  },
                  child: Container(
                    height: screen.setHeight(35),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 8),
                    child: FaIcon(
                      FontAwesomeIcons.calendarAlt,
                      color: Color(0xFF515151),
                      size: ScreenUtil().setWidth(15),
                    ),
                  ),
                ),
              ),
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
                color: Color(0xFF515151),
                fontWeight: FontWeight.w700)));
  }

  Widget searchAppbar() {
    return GetX<SappBarController>(initState: (state) {
      Get.find<SappBarController>().initSearchBar();
    }, builder: (_) {
      return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOutExpo,
          // padding: EdgeInsets.only(left: ScreenUtil().setWidth(18)),
          height: controller.searchBarHeight.value,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: screen.setHeight(35),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(18)),
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.search,
                      color: Color(0xFF515151),
                      size: ScreenUtil().setWidth(15),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(240),
                    height: ScreenUtil().setHeight(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF4F3F3F3),
                    ),
                    margin: EdgeInsets.only(
                      right: ScreenUtil().setWidth(8),
                    ),
                    child: TextField(
                      controller: controller.searchTextEditingController,
                      focusNode: controller.searchFocusNode,
                      onSubmitted: (value) {
                        SearchController searchController =
                            Get.find<SearchController>();

                        searchController.searchKeywords =
                            controller.searchTextEditingController.text;
                        if (!searchController.currentOnLoading.value) {
                          Get.find<WaterFlowController>(tag: 'search')
                              .refreshIllustList(
                                  searchKeyword: controller
                                      .searchTextEditingController.text);
                        }
                        Get.put(
                            WaterFlowController(
                                model: 'search',
                                searchKeyword: controller
                                    .searchTextEditingController.text),
                            tag: 'search');
                        searchController.currentOnLoading.value = false;

                        // widget.searchFucntion(searchController.text);
                      },
                      onChanged: (value) {
                        print(value);
                        // if (value == '') {
                        //   widget.searchFucntion(value);
                        // }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '要搜点什么呢',
                        contentPadding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(8),
                            bottom: ScreenUtil().setHeight(9)),
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () async {
                        if (Get.find<GlobalController>().isLogin.value) {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null)
                            Get.find<SearchController>().searchSimilarPicture(
                                File(result.files.first.path!));
                          else
                            BotToast.showSimpleNotification(
                                title: texts.noImageSelected);
                        }
                      },
                      icon: Icon(Icons.camera_enhance),
                    ),
                  ),
                ],
              ),
              _.searchBarHeight.value == screen.setHeight(35)
                  ? Container()
                  : searchAdditionGroup()
            ],
          )));
    });
  }

  Widget searchAdditionGroup() {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(285),
      margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          searchAdditionCell(texts.transAndSearch,
              onTap: () => Get.find<SearchController>().transAndSearchTap(
                  controller.searchTextEditingController.text)),
          searchAdditionCell(texts.idToArtist, onTap: () {}),
          searchAdditionCell(texts.idToIllust,
              onTap: () => Get.find<SearchController>().searchIllustById(
                  int.parse(controller.searchTextEditingController.text))),
        ],
      ),
    );
  }

  Widget searchAdditionCell(String label, {required Function onTap}) {
    return GetBuilder<SappBarController>(builder: (_) {
      return GestureDetector(
        onTap: () {
          if (_.searchTextEditingController.text != '') {
            onTap();
          } else {
            BotToast.showSimpleNotification(title: texts.inputError);
          }
        },
        child: Container(
          height: ScreenUtil().setHeight(26),
          width: ScreenUtil().setWidth(89),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(13),
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 15,
                  offset: Offset(5, 5),
                  color: Color(0x73E5E5E5)),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
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
          Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                // print(widget.collectionSetting);
                // widget.collectionSetting(context);
                Get.find<CollectionSelectorCollector>()
                    .showCollectionInfoEditDialog();
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
          ),
        ],
      ),
    );
  }

  ///将点击事件放在controller中

}
