import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/pic_texts.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:sharemoe/routes/app_pages.dart';

import 'collection_detail_controller.dart';

class CollectionSelectorCollector extends GetxController
    with SingleGetTickerProviderMixin {
  List<int> selectList = [];
late  AnimationController animationController;
 late Animation animation;
 late bool selectMode;
 late Collection collection;
  List<TagList> tagAdvice = [];
  bool isCreate;
  int isPublic = 1;
  int pornWarning = 1;
  int forbidComment = 1;
  List<TagList> tagList = [];

  // final collectionList=Rx<List<int>>([]);
  final ScreenUtil screen = ScreenUtil();

 late TextEditingController title;
 late TextEditingController caption;
 late TextEditingController tagComplement;

  CollectionSelectorCollector({required this.isCreate});

  void clearSelectList() {
    for (int i = 0; i < selectList.length; i++) {
      Get.find<ImageController>(tag: selectList[i].toString())
          .isSelector
          .value = false;
    }
    selectList = [];
    animationController.reverse();
    update();
  }

  void addIllustToCollectList(Illust illust) {
    if (selectList.length == 0) animationController.forward();
    selectList.add(illust.id);
    update();
  }

  void removeIllustToSelectList(Illust illust) {
    selectList.removeWhere((element) => element == illust.id);
    if (selectList.length == 0) animationController.reverse();
    update();
  }

  addIllustToCollection(int collectionId) async {
    await getIt<CollectionRepository>()
        .queryAddIllustToCollection(collectionId, selectList)
        .then((value) {
      clearSelectList();
      Get.back();
    });
  }

  removeFromCollection() async {
    await getIt<CollectionRepository>()
        .queryBulkDeleteCollection(collection.id, selectList)
        .then((value) {
      Get.find<WaterFlowController>(tag: 'collection').refreshIllustList();
    });
  }

  switchPublic(int value) {
    isCreate ? isPublic = value : collection.isPublic = value;
    update(['public']);
  }

  switchAllowComment(int value) {
    isCreate ? forbidComment = value : collection.forbidComment = value;
    update(['allowComment']);
  }

  switchPornWaring(int value) {
    isCreate ? pornWarning = value : collection.pornWarning = value;
    update(['pornWaring']);
  }

  updateTitle() {
    collection.title = title.text;
    collection.caption = caption.text;
    update(['title']);
    Get.find<CollectionController>().updateTitle(title.text, collection.tagList,
        Get.find<CollectionDetailController>().index);
  }

  getTagAdvice() async {
    tagAdvice = tagAdvice +
        await getIt<CollectionRepository>()
            .queryTagComplement(tagComplement.text);
    update(['tagComplement']);
  }

  addTagToTagsList(TagList tag) {
    if (isCreate) {
      if (!(this.tagList).contains(tagList)) this.tagList.add(tag);
    } else {
      if (!(collection.tagList).contains(tagList)) collection.tagList.add(tag);
    }

    update(['changeTag']);
  }

  removeTagFromTagsList(TagList tag) {
    if(isCreate){
      this.tagList
          .removeWhere((element) => element.tagName == tag.tagName);
    }
    else{

      collection.tagList
          .removeWhere((element) => element.tagName == tag.tagName);
    }

    update(['changeTag']);
  }

  postNewCollection() async {
    Map<String, dynamic> payload = {
      'username': picBox.get('name'),
      'title': title.text,
      'caption': caption.text,
      'isPublic': isPublic,
      'pornWarning': pornWarning,
      'forbidComment': forbidComment,
      'tagList': tagList
    };
    getIt<CollectionRepository>()
        .queryCreateCollection(payload, picBox.get('auth')[0])
        .then((value) {
      Get.back();
      Get.find<CollectionController>().refreshList();
      title.text = '';
      caption.text = '';
      tagComplement.text = '';
      tagList = [];
      tagAdvice = [];
    });
  }

  deleteCollection() {
    final texts = TextZhPicDetailPage();
    return Get.dialog(AlertDialog(
      title: Text(texts.deleteCollectionTitle),
      content: Text(texts.deleteCollectionContent),
      actions: [
        FlatButton(
            onPressed: () {
              Get.back();
            },
            child: Text(texts.deleteCollectionNo)),
        FlatButton(
          onPressed: () async {
            getIt<CollectionRepository>()
                .queryDeleteCollection(collection.id)
                .then((value) {
              Get.back();
              Get.back();
              Get.find<CollectionController>().refreshList();
              Get.back();
            });
          },
          child: Text(
            texts.deleteCollectionYes,
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    ));
  }

  putEditCollection() async {
    Map<String, dynamic> payload = {
      'id': collection.id,
      'username': picBox.get('name'),
      'title': title.text,
      'caption': caption.text,
      'isPublic': collection.isPublic,
      'pornWarning': collection.pornWarning,
      'forbidComment': collection.forbidComment,
      'tagList': collection.tagList
    };

    if (collection.tagList != null) {
      await getIt<CollectionRepository>()
          .queryUpdateCollection(collection.id, payload)
          .then((value) {
        updateTitle();
        Get.back();
      });
    }
  }

  setCollectionCover() async {
    await getIt<CollectionRepository>()
        .queryModifyCollectionCover(collection.id, selectList)
        .then((value) {
      clearSelectList();
      Get.find<CollectionController>().refreshList();
    });
  }

  showCollectionInfoEditDialog() {
    TextZhCollection texts = TextZhCollection();
    if (!isCreate) {
      title.text = collection.title;
      caption.text = collection.caption;
    }
    return Get.dialog(AlertDialog(
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
                    child: Text(isCreate ? texts.newCollectionTitle : '画集')),
                TextField(
                  cursorColor: Colors.orange,
                  controller: title,
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
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                ),
                TextField(
                  cursorColor: Colors.orange,
                  controller: caption,
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
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                ),
                GetBuilder<CollectionSelectorCollector>(
                    id: 'public',
                    builder: (_) {
                      return SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        value: (isCreate ? isPublic : collection.isPublic) == 1
                            ? true
                            : false,
                        dense: true,
                        onChanged: (bool value) {
                          value ? switchPublic(1) : switchPublic(0);
                        },
                        activeColor: Colors.orangeAccent,
                        title:
                            Text(texts.isPulic, style: TextStyle(fontSize: 14)),
                      );
                    }),
                GetBuilder<CollectionSelectorCollector>(
                    id: 'allowComment',
                    builder: (_) {
                      return SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        value: (isCreate
                                    ? forbidComment
                                    : collection.forbidComment) ==
                                1
                            ? true
                            : false,
                        onChanged: (bool value) {
                          value ? switchAllowComment(1) : switchAllowComment(0);
                        },
                        activeColor: Colors.orangeAccent,
                        title: Text(texts.allowComment,
                            style: TextStyle(fontSize: 14)),
                      );
                    }),
                GetBuilder<CollectionSelectorCollector>(
                    id: 'pornWaring',
                    builder: (_) {
                      return SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 50),
                        value:
                            (isCreate ? pornWarning : collection.pornWarning) ==
                                    1
                                ? true
                                : false,
                        onChanged: (bool value) {
                          value ? switchPornWaring(1) : switchPornWaring(0);
                        },
                        activeColor: Colors.orangeAccent,
                        title:
                            Text(texts.isSexy, style: TextStyle(fontSize: 14)),
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
                !isCreate
                    ? FlatButton(
                        shape: StadiumBorder(),
                        onPressed: () {
                          deleteCollection();
                        },
                        child: Text(
                          texts.removeCollection,
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    : SizedBox(),
                Container(
                  color: Colors.orangeAccent,
                  child: FlatButton(
                      // padding: EdgeInsets.all(0),
                      minWidth: screen.setWidth(250),
                      color: Colors.orangeAccent,
                      shape: StadiumBorder(),
                      onPressed: () {
                        isCreate ? postNewCollection() : putEditCollection();
                      },
                      child: Text(isCreate
                          ? texts.createCollection
                          : texts.editCollection)),
                ),
              ],
            ),
          ),
        )));
  }

  showTagSelector() {
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
                  GetBuilder<CollectionSelectorCollector>(
                      id: 'changeTag',
                      builder: (_) {
                        return Container(
                          width: screen.setWidth(250),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: (isCreate ? tagList : collection.tagList)
                                .map((item) => singleTag(item, false))
                                .toList(),
                          ),
                        );
                      }),
                  Container(
                    width: ScreenUtil().setWidth(200),
                    child: TextField(
                        controller: tagComplement,
                        decoration: InputDecoration(
                          hintText: '输入你想要添加的标签',
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        onEditingComplete: () {
                          getTagAdvice();
                        }),
                  ),
                  GetBuilder<CollectionSelectorCollector>(
                      id: 'tagComplement',
                      builder: (_) {
                        return Container(
                          width: ScreenUtil().setWidth(250),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: tagAdvice
                                .map((item) => singleTag(item, true))
                                .toList(),
                          ),
                        );
                      }),
                ],
              )),
        )));
  }

  Widget singleTag(TagList tagList, bool advice) {
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
            if (advice) {
              addTagToTagsList(tagList);
            } else {
              removeTagFromTagsList(tagList);
            }
          },
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                tagList.tagName,
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

  @override
  void onInit() {
    selectMode = true;
    animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    animation =
        Tween<double>(begin: 0.0, end: 40.0).animate(animationController)
          ..addListener(() {
            update();
          });
    title = TextEditingController();
    caption = TextEditingController();
    tagComplement = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
