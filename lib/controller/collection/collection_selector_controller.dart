// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/controller/global_controller.dart';
import 'package:sharemoe/controller/image_controller.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'collection_detail_controller.dart';

class CollectionSelectorCollector extends GetxController
    with SingleGetTickerProviderMixin {
  List<int> selectList = [];
  late AnimationController animationController;
  late Animation animation;
  late bool selectMode;
  late Collection collection;
  List<TagList> tagAdvice = [];
  bool isCreate;
  int isPublic = 1;
  int pornWarning = 0;
  int forbidComment = 1;
  List<TagList> tagList = [];
  static final UserService userService = getIt<UserService>();
  static CollectionRepository collectionRepository =
      getIt<CollectionRepository>();

  late TextEditingController title;
  late TextEditingController caption;
  late TextEditingController tagComplement;

  CollectionSelectorCollector({required this.isCreate});

//清空所选画集
  void clearSelectList() {
    for (int i = 0; i < selectList.length; i++) {
      //取消选择模式
      Get.find<ImageController>(
              tag: selectList[i].toString() +
                  Get.find<GlobalController>().isLogin.value.toString())
          .isSelector
          .value = false;
    }
    selectList.clear();
    animationController.reverse();
    update();
  }

//添加画作到预选画集List
  void addIllustToCollectList(Illust illust) {
    if (selectList.length == 0) animationController.forward();
    selectList.add(illust.id);
    update();
  }

//从所选列表删除画集
  void removeIllustToSelectList(Illust illust) {
    selectList.removeWhere((element) => element == illust.id);
    if (selectList.length == 0) animationController.reverse();
    update();
  }

//添加画作到画集
  addIllustToCollection(int collectionId, {List<int>? illustList}) async {
    await collectionRepository
        .queryAddIllustToCollection(collectionId, illustList ?? selectList)
        .then((value) {
      clearSelectList();
      Get.back();
    });
  }

//从画集中删除画作
  removeFromCollection() async {
    await collectionRepository
        .queryBulkDeleteCollection(collection.id, selectList)
        .then((value) {
      Get.find<WaterFlowController>(tag: 'collection').refreshIllustList();
    });
  }

//是否公开选择按钮
  switchPublic(int value) {
    isCreate ? isPublic = value : collection.isPublic = value;
    update(['public']);
  }

//是否允许评论按钮
  switchAllowComment(int value) {
    isCreate ? forbidComment = value : collection.forbidComment = value;
    update(['allowComment']);
  }

//是否sex按钮
  switchPornWaring(int value) {
    isCreate ? pornWarning = value : collection.pornWarning = value;
    update(['pornWaring']);
  }

//更新画集标题
  updateTitle() {
    collection.title = title.text;
    collection.caption = caption.text;
    update(['title']);
    Get.find<CollectionController>().updateTitle(title.text, collection.tagList,
        Get.find<CollectionDetailController>().index);
  }

//获取建议tag
  getTagAdvice(String tagText) async {
    tagAdvice.add(TagList(tagName: tagText));
    update(['tagComplement']);
    tagAdvice.addAll(
        await collectionRepository.queryTagComplement(tagComplement.text));

    update(['tagComplement']);
  }

//添加tag到dialog
  addTagToTagsList(TagList tag) {
    if (isCreate) {
      if (tagList.length >= 5)
        return BotToast.showSimpleNotification(title: '最多可添加5个tag');
      if (!(this.tagList).contains(tag)) this.tagList.add(tag);
    } else {
      if (collection.tagList.length >= 5)
        return BotToast.showSimpleNotification(title: '最多可添加5个tag');
      if (!(collection.tagList).contains(tag)) collection.tagList.add(tag);
    }

    update(['changeTag']);
  }

//从dialog删除tag
  removeTagFromTagsList(TagList tag) {
    if (isCreate) {
      this.tagList.removeWhere((element) => element.tagName == tag.tagName);
    } else {
      collection.tagList
          .removeWhere((element) => element.tagName == tag.tagName);
    }

    update(['changeTag']);
  }

//创建新的画集
  postNewCollection() async {
    Map<String, dynamic> payload = {
      'username': userService.userInfo()!.username,
      'title': title.text,
      'caption': caption.text,
      'isPublic': isPublic,
      'pornWarning': pornWarning,
      'forbidComment': forbidComment,
      'tagList': tagList
    };
    collectionRepository
        .queryCreateCollection(payload, await UserService.queryToken())
        .then((value) {
      if (Get.isRegistered<CollectionController>())
        Get.find<CollectionController>().refreshList();
      BotToast.showSimpleNotification(title: '创建成功');
      Get.back();
      title.clear();
      caption.clear();
      tagComplement.clear();
      tagList.clear();
      tagAdvice.clear();
    });
  }

//删除画集
  deleteCollection() {
    return Get.dialog(AlertDialog(
      title: Text(TextZhPicDetailPage.deleteCollectionTitle),
      content: Text(TextZhPicDetailPage.deleteCollectionContent),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(TextZhPicDetailPage.deleteCollectionNo)),
        TextButton(
          onPressed: () async {
            collectionRepository
                .queryDeleteCollection(collection.id)
                .then((value) {
              Get.back();
              Get.back();
              Get.find<CollectionController>().refreshList();
              Get.back();
            });
            title.clear();
            caption.clear();
            tagComplement.clear();
            tagList.clear();
            tagAdvice.clear();
          },
          child: Text(
            TextZhPicDetailPage.deleteCollectionYes,
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    ));
  }

//更新画集
  putEditCollection() async {
    Map<String, dynamic> payload = {
      'id': collection.id,
      'username': userService.userInfo()!.username,
      'title': title.text,
      'caption': caption.text,
      'isPublic': collection.isPublic,
      'pornWarning': collection.pornWarning,
      'forbidComment': collection.forbidComment,
      'tagList': collection.tagList
    };

    if (collection.tagList.isNotEmpty) {
      await collectionRepository
          .queryUpdateCollection(collection.id, payload)
          .then((value) {
        updateTitle();
        Get.back();
      });
    }
  }

//设置画集封面
  setCollectionCover() async {
    await collectionRepository
        .queryModifyCollectionCover(collection.id, selectList)
        .then((value) {
      clearSelectList();
      Get.find<CollectionController>().refreshList();
    });
  }

//显示画集信息dialog
  showCollectionInfoEditDialog() {
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
            width: 250.w,
            height: 370.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10),
                    color: Colors.orangeAccent,
                    child: Text(
                        isCreate ? TextZhCollection.newCollectionTitle : '画集')),
                TextField(
                  cursorColor: Colors.orange,
                  controller: title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                      color: Colors.grey[700]),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent)),
                    isDense: true,
                    focusColor: Colors.orange,
                    hintText: TextZhCollection.inputCollectionTitle,
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
                      fontSize: 11.sp,
                      color: Colors.grey[500]),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent)),
                    isDense: true,
                    hintText: TextZhCollection.inputCollectionCaption,
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
                        title: Text(TextZhCollection.isPulic,
                            style: TextStyle(fontSize: 14)),
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
                        title: Text(TextZhCollection.allowComment,
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
                        title: Text(TextZhCollection.isSexy,
                            style: TextStyle(fontSize: 14)),
                      );
                    }),
                TextButton(
                  onPressed: () {
                    showTagSelector();
                  },
                  child: Text(
                    TextZhCollection.addTag,
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.w600),
                  ),
                ),
                !isCreate
                    ? TextButton(
                        onPressed: () {
                          deleteCollection();
                        },
                        child: Text(
                          TextZhCollection.removeCollection,
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    : SizedBox(),
                Container(
                  color: Colors.orangeAccent,
                  child: MaterialButton(
                      elevation: 0,
                      // padding: EdgeInsets.all(0),
                      minWidth: 250.w,
                      color: Colors.orangeAccent,
                      shape: StadiumBorder(),
                      onPressed: () {
                        isCreate ? postNewCollection() : putEditCollection();
                      },
                      child: Text(isCreate
                          ? TextZhCollection.createCollection
                          : TextZhCollection.editCollection)),
                ),
              ],
            ),
          ),
        )));
  }

//显示选择tag_dialog
  showTagSelector() {
    return Get.dialog(AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: EdgeInsets.all(0),
        content: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: Container(
              constraints: BoxConstraints(minHeight: 200.h),
              // width: 270.w,
              // height: 200.h,

              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          width: 250.h,
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
                          // getTagAdvice();
                        }),
                  ),
                  GetBuilder<CollectionSelectorCollector>(
                      id: 'tagComplement',
                      builder: (_) {
                        return Container(
                          height: 10,
                          padding: EdgeInsets.all(5.h),
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
        // ignore: deprecated_member_use
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

  showAddToCollection({int? illustId}) {
    final screen = ScreenUtil();
    return Get.dialog(GetX<CollectionController>(
      init: CollectionController(),
      builder: (_) {
        return _.collectionList.value.isEmpty
            ? AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                content: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Lottie.asset('assets/image/empty-box.json',
                        repeat: false, height: ScreenUtil().setHeight(80)),
                    Container(
                      // width: screen.setWidth(300),
                      padding: EdgeInsets.only(top: screen.setHeight(8)),
                      child: Text(TextZhPicDetailPage.addFirstCollection),
                    ),
                    Container(
                      width: screen.setWidth(100),
                      padding: EdgeInsets.only(top: screen.setHeight(8)),
                      child: TextButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          // controller.showCollectionInfoEditDialog();
                          Get.toNamed(Routes.COLLECTION_CREATE_PUT,
                              preventDuplicates: false);
                        },
                      ),
                    )
                  ],
                ),
              )
            : AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                scrollable: true,
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      padding: EdgeInsets.only(bottom: screen.setHeight(5)),
                      alignment: Alignment.center,
                      child: Text(
                        TextZhPicDetailPage.addToCollection,
                        style: TextStyle(color: Colors.orangeAccent),
                      )),
                  Container(
                    height: 400,
                    // height: screen.setHeight(tuple2.item1.length <= 7
                    //     ? screen.setHeight(50) * tuple2.item1.length
                    //     : screen.setHeight(50) * 7),
                    width: screen.setWidth(250),
                    child: ListView.builder(
                        itemCount: _.collectionList.value.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            child: ListTile(
                              title: Text(_.collectionList.value[index].title),
                              subtitle:
                                  Text(_.collectionList.value[index].caption),
                              onTap: () {
                                addIllustToCollection(
                                    _.collectionList.value[index].id,
                                    illustList:
                                        illustId == null ? null : [illustId]);
                              },
                            ),
                          );
                        }),
                  ),
                  Container(
                      width: screen.setWidth(100),
                      padding: EdgeInsets.only(top: screen.setHeight(8)),
                      child: TextButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            // Navigator.of(context).pop();
                            // controller.showCollectionInfoEditDialog();
                            Get.toNamed(Routes.COLLECTION_CREATE_PUT,
                                preventDuplicates: false);
                          })),
                ]),
              );
      },
    ));
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
    animationController.dispose();
    title.dispose();
    caption.dispose();
    tagComplement.dispose();
    super.onClose();
  }
}
