// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class CreateOrPutCollectionPage extends GetView<CollectionSelectorCollector> {
  CreateOrPutCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!controller.isCreate) {
      controller.title.text = controller.collection.title;
      controller.caption.text = controller.collection.caption;
    }
    controller.tagAdvice.clear();
    return Scaffold(
      appBar: SappBar.normal(title: controller.isCreate ? '新建画集' : '修改画集'),
      body: Padding(
        padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              collectionTextField(
                  title: '画集标题',
                  hintText: '在此输入画集的标题',
                  textEditingController: controller.title),
              SizedBox(height: 20.h),
              collectionTextField(
                  title: '画集简介',
                  hintText: '介绍你的画集主题、内容和想法',
                  textEditingController: controller.caption),
              SizedBox(height: 20.h),
              collectionTextField(
                  title: '画集标签',
                  hintText: '搜索标签并选择，至多添加5个标签',
                  textEditingController: controller.tagComplement),
              Container(
                padding: EdgeInsets.only(top: 5.h),
                // height: 50.h,
                child: GetBuilder<CollectionSelectorCollector>(
                    id: 'changeTag',
                    builder: (_) {
                      return controller.isCreate
                          ? Wrap(
                              alignment: WrapAlignment.start,
                              children: controller.tagList
                                  .map((item) => singleTag(item, false))
                                  .toList(),
                            )
                          : Wrap(
                              alignment: WrapAlignment.start,
                              children: controller.collection.tagList
                                  .map((item) => singleTag(item, false))
                                  .toList(),
                            );
                    }),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.h),
                width: 294.w,
                height: 84.h,
                // margin: EdgeInsets.symmetric(horizontal: 0.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Color(0xffDEE3FF),
                ),
                child: SingleChildScrollView(
                  child: GetBuilder<CollectionSelectorCollector>(
                      id: 'tagComplement',
                      builder: (_) {
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: controller.tagAdvice
                              .map((item) => singleTag(item, true))
                              .toList(),
                        );
                      }),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "其它设定",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  GetBuilder<CollectionSelectorCollector>(
                      id: 'public',
                      builder: (_) {
                        return SizedBox(
                          height: 16.w,
                          width: 16.w,
                          child: Checkbox(
                            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.w)),
                            value: (controller.isCreate
                                        ? controller.isPublic
                                        : controller.collection.isPublic) ==
                                    1
                                ? true
                                : false,
                            onChanged: (bool? value) {
                              value!
                                  ? controller.switchPublic(1)
                                  : controller.switchPublic(0);
                            },
                          ),
                        );
                      }),
                  SizedBox(width: 4.w),
                  Text(
                    '公开画集',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xffF7AF2B),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  GetBuilder<CollectionSelectorCollector>(
                      id: 'allowComment',
                      builder: (_) {
                        return SizedBox(
                          height: 16.w,
                          width: 16.w,
                          child: Checkbox(
                            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.w)),
                            value: (controller.isCreate
                                        ? controller.forbidComment
                                        : controller
                                            .collection.forbidComment) ==
                                    1
                                ? true
                                : false,
                            onChanged: (bool? value) {
                              if (value!) {
                                controller.switchAllowComment(1);
                                controller.switchPublic(1);
                              } else {
                                controller.switchAllowComment(0);
                              }

                              // value!
                              //     ? controller.switchAllowComment(1)
                              //     : controller.switchAllowComment(0);
                            },
                          ),
                        );
                      }),
                  SizedBox(width: 4.w),
                  Text(
                    '允许评论',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xffF7AF2B),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  GetBuilder<CollectionSelectorCollector>(
                      id: 'pornWaring',
                      builder: (_) {
                        return SizedBox(
                          height: 16.h,
                          width: 16.w,
                          child: Checkbox(
                            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.w)),
                            value: (controller.isCreate
                                        ? controller.pornWarning
                                        : controller.collection.pornWarning) ==
                                    1
                                ? true
                                : false,
                            onChanged: (bool? value) {
                              value!
                                  ? controller.switchPornWaring(1)
                                  : controller.switchPornWaring(0);
                            },
                          ),
                        );
                      }),
                  SizedBox(width: 4.w),
                  Text(
                    '含R16内容',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xffF7AF2B),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: controller.isCreate
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  !controller.isCreate
                      ? TextButton(
                          onPressed: () {
                            controller.deleteCollection();
                          },
                          style: ButtonStyle(
                              alignment: Alignment.topCenter,
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          child: Text('删除画集',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)))
                      : SizedBox(),
                  TextButton(
                      onPressed: () {
                        if (controller.isCreate) {
                          controller.postNewCollection();
                          controller.tagAdvice.clear();
                          controller.title.clear();
                          controller.caption.clear();
                        } else
                          controller.putEditCollection();
                      },
                      style: ButtonStyle(
                          alignment: Alignment.topCenter,
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Text(controller.isCreate ? '立即创建' : '立即修改',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffF7AF2B))))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget collectionTextField(
      {required String title,
      required String hintText,
      required TextEditingController textEditingController}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: EdgeInsets.only(left: 16.w),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xff515151),
              ),
            ),
          ),
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 5.h, bottom: 1.h),
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 10.sp, color: Color(0xffBFBFBF)),
                suffix: title == "画集标签"
                    ? IconButton(
                        onPressed: () {
                          controller.tagAdvice = [];
                          controller
                              .getTagAdvice(controller.tagComplement.text);
                        },
                        icon: Icon(Icons.search_rounded))
                    : null),
            onEditingComplete: title == "画集标签"
                ? () {
                    controller.tagAdvice = [];
                    controller.getTagAdvice(textEditingController.text);
                  }
                : null,
          )
        ],
      ),
    );
  }

  Widget singleTag(TagList tagList, bool advice) {
    return Container(
      height: 16.h,
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(1.5),
          right: ScreenUtil().setWidth(1.5),
          top: ScreenUtil().setWidth(4),
          bottom: 5.h),
      child: ButtonTheme(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //set _InputPadding to zero
        height: ScreenUtil().setHeight(16),
        minWidth: ScreenUtil().setWidth(1),
        buttonColor: Colors.grey[100],
        splashColor: Colors.grey[100],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.only(
              left: ScreenUtil().setWidth(5),
              right: ScreenUtil().setWidth(5),
            )),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.w))),
            ),
          ),
          // padding: EdgeInsets.only(
          //   left: ScreenUtil().setWidth(5),
          //   right: ScreenUtil().setWidth(5),
          // ),
          onPressed: () {
            if (advice) {
              controller.addTagToTagsList(tagList);
            } else {
              controller.removeTagFromTagsList(tagList);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
}
