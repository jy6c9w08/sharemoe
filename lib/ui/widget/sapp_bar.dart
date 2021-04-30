import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:sharemoe/basic/texts.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/controller/collection/collection_detail_controller.dart';
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/controller/sapp_bar_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/page/pic/home_bottom_sheet.dart';
import 'package:sharemoe/basic/texts.dart';

class SappBar extends StatelessWidget implements PreferredSizeWidget {
  final ScreenUtil screen = ScreenUtil();
  final String title;
  final String model;
  final DateTime _picFirstDate = DateTime(2008, 1, 1);
  final DateTime _picLastDate = DateTime.now().subtract(Duration(hours: 39));

  final TextZhPappBar texts = TextZhPappBar();

  SappBar({this.title, this.model = 'default'});

  SappBar.home({this.title, this.model = 'home'}) : super();

  SappBar.search({this.title, this.model = 'search'}) : super();

  SappBar.collection({this.title, this.model = 'collection'}) : super();

  @override
  Size get preferredSize => Size.fromHeight(screen.setHeight(77));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 13,
                  offset: Offset(5, 5),
                  color: Color(0x73E5E5E5)),
            ],
          ),
          child: chooseAppBar(),
        ));
  }

  Widget chooseAppBar() {
    switch (model) {
      case 'home':
        return homeAppBar();
      case 'default':
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
                    DateTime newDate = await showDatePicker(
                      context: Get.context,
                      initialDate: flowController.picDate,
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
        child: Text(title,
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
          height: _.searchBarHeight.value,
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
                      left: ScreenUtil().setWidth(10),
                      right: ScreenUtil().setWidth(8),
                    ),
                    child: TextField(
                      controller: _.searchController,
                      focusNode: _.searchFocusNode,
                      onSubmitted: (value) {
                        SearchController searchController =
                            Get.find<SearchController>();

                        searchController.searchKeywords =
                            _.searchController.text;
                        if (!searchController.currentOnLoading.value) {
                          Get.find<WaterFlowController>(tag: 'search')
                              .refreshIllustList(
                                  searchKeyword: _.searchController.text);
                        }
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
                    child: InkWell(
                      onTap: () async {
                        // bool loginState = hasLogin();
                        // if (loginState) {
                        //   File file = await FilePicker.getFile(
                        //       type: FileType.image);
                        //   if (file != null) {
                        //     uploadImageToSaucenao(file, context);
                        //   } else {
                        //     BotToast.showSimpleNotification(
                        //         title: texts.noImageSelected);
                        //   }
                        // }
                      },
                      child: Icon(
                        Icons.camera_enhance,
                      ),
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
          searchAdditionCell(texts.transAndSearch, onTap: () {}),
          searchAdditionCell(texts.idToArtist, onTap: () {}),
          searchAdditionCell(texts.idToIllust, onTap: () {}),
        ],
      ),
    );
  }

  Widget searchAdditionCell(String label, {Function onTap}) {
    return GetBuilder<SappBarController>(builder: (_) {
      return GestureDetector(
        onTap: () {
          if (_.searchController.text != '') {
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
                showCollectionInfoEditDialog();
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

  showCollectionInfoEditDialog() {
    CollectionDetailController controller =
        Get.find<CollectionDetailController>();
    TextZhCollection texts = TextZhCollection();
    return Get.dialog(
      AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(0),
          content: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: Container(
              alignment: Alignment.topCenter,
              width: screen.setWidth(250),
              height: screen.setHeight(370),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 10),
                      color: Colors.orangeAccent,
                      child: Text('画集')),
                  TextField(
                    cursorColor: Colors.orange,
                    controller: controller.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screen.setSp(13),
                        color: Colors.grey[700]),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent)),
                      isDense: true,
                      focusColor: Colors.orange,
                      hintText: texts.inputCollectionTitle,
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ),
                  TextField(
                    cursorColor: Colors.orange,
                    controller: controller.caption,
                    maxLines: 3,
                    minLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: screen.setSp(11),
                        color: Colors.grey[500]),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent)),
                      isDense: true,
                      hintText: texts.inputCollectionCaption,
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ),
                  GetBuilder<CollectionDetailController>(
                      id: 'public',
                      builder: (_) {
                        return SwitchListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 50),
                          value: _.collection.isPublic == 1 ? true : false,
                          dense: true,
                          onChanged: (bool value) {
                            value ? _.switchPublic(1) : _.switchPublic(0);
                          },
                          activeColor: Colors.orangeAccent,
                          title: Text(texts.isPulic,
                              style: TextStyle(fontSize: 14)),
                        );
                      }),
                  GetBuilder<CollectionDetailController>(
                      id: 'allowComment',
                      builder: (_) {
                        return SwitchListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 50),
                          value: _.collection.forbidComment == 1 ? true : false,
                          onChanged: (bool value) {
                            value
                                ? _.switchAllowComment(1)
                                : _.switchAllowComment(0);
                          },
                          activeColor: Colors.orangeAccent,
                          title: Text(texts.allowComment,
                              style: TextStyle(fontSize: 14)),
                        );
                      }),
                  GetBuilder<CollectionDetailController>(
                      id: 'pornWaring',
                      builder: (_) {
                        return SwitchListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 50),
                          value: _.collection.pornWarning == 1 ? true : false,
                          onChanged: (bool value) {
                            value
                                ? _.switchPornWaring(1)
                                : _.switchPornWaring(0);
                          },
                          activeColor: Colors.orangeAccent,
                          title: Text(texts.isSexy,
                              style: TextStyle(fontSize: 14)),
                        );
                      }),
                  FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      // showTagSelector(context);
                      showTagSelector();
                    },
                    child: Text(
                      texts.addTag,
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.w600),
                    ),
                  ),
                  FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      // showTagSelector(context);
                    },
                    child: Text(
                      texts.removeCollection,
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    color: Colors.orangeAccent,
                    child: FlatButton(
                        // padding: EdgeInsets.all(0),
                        minWidth: screen.setWidth(250),
                        color: Colors.orangeAccent,
                        shape: StadiumBorder(),
                        onPressed: () {
                          controller.putEditCollection();
                        },
                        child: Text(texts.editCollection)),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  showTagSelector() {
    CollectionDetailController controller =
        Get.find<CollectionDetailController>();
    TextZhCollection texts = TextZhCollection();
    return Get.dialog(AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: EdgeInsets.all(0),
        content: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
              width: screen.setWidth(270),
              height: screen.setWidth(500),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 10),
                      color: Colors.orangeAccent,
                      child: Text('添加标签')),

                  Container(
                    width: screen.setWidth(250),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: controller.collection.tagList
                          .map((item) => singleTag(item, false))
                          .toList(),
                    ),
                  ),

                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: TextField(
                        // controller: tagInput,
                        decoration: InputDecoration(
                          hintText: '输入你想要添加的标签',
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        onEditingComplete: () {
                          // newCollectionParameterModel
                          //     .getTagAdvice(tagInput.text);
                        }),
                  ),

                  // Container(
                  //   width: ScreenUtil().setWidth(250),
                  //   child: Wrap(
                  //     alignment: WrapAlignment.center,
                  //     children: newCollectionParameterModel
                  //         .tagsAdvice
                  //         .map((item) =>
                  //         singleTag(context, item, true))
                  //         .toList(),
                  //   ),
                  // ),
                ],
              )),
        )));
  }

  Widget singleTag(TagList data, bool advice) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(1.5),
          right: ScreenUtil().setWidth(1.5),
          top: ScreenUtil().setWidth(4)),
      child: ButtonTheme(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //set _InputPadding to zero
        height: ScreenUtil().setHeight(20),
        minWidth: ScreenUtil().setWidth(1),
        buttonColor: Colors.grey[100],
        splashColor: Colors.grey[100],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
        child: OutlineButton(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(5),
            right: ScreenUtil().setWidth(5),
          ),
          onPressed: () {
            // if (advice) {
            //   Provider.of<NewCollectionParameterModel>(context, listen: false)
            //       .addTagToTagsList(data);
            // } else {
            //   Provider.of<NewCollectionParameterModel>(context, listen: false)
            //       .removeTagFromTagsList(data);
            // }
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                data.tagName,
                style: TextStyle(color: Colors.grey),
              ),
              !advice
                  ? Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: ScreenUtil().setWidth(13),
                    )
                  : SizedBox(width: 0)
            ],
          ),
        ),
      ),
    );
  }
}
