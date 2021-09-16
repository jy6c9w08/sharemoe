// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      backgroundColor: Colors.white,
      appBar: SappBar.normal(title: controller.isCreate ? '新建画集' : '修改画集'),
      body: Padding(
        padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 43.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '画集标题',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xff515151),
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      controller: controller.title,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(top: 5.h, bottom: 1.h),
                        hintText: '在此输入画集的标题',
                        hintStyle: TextStyle(
                            fontSize: 10.sp, color: Color(0xffBFBFBF)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 43.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      '画集简介',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xff515151),
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller.caption,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 5.h, bottom: 1.h),
                      hintText: '介绍你的画集主题、内容和想法',
                      hintStyle:
                          TextStyle(fontSize: 10.sp, color: Color(0xffBFBFBF)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 43.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      '画集标签',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xff515151),
                      ),
                    ),
                  ),
                  TextField(
                      controller: controller.tagComplement,
                      decoration: InputDecoration(
                        suffix: InkWell(
                          onTap: () {
                            controller.tagAdvice = [];
                            controller
                                .getTagAdvice(controller.tagComplement.text);
                          },
                          child: SvgPicture.asset(
                            'assets/icon/search.svg',
                            width: 12.w,
                            height: 12.h,
                          ),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.only(top: 5.h, bottom: 1.h),
                        // contentPadding: EdgeInsets.a,
                        hintText: '搜索标签并选择，至多添加5个标签',
                        hintStyle: TextStyle(
                            fontSize: 10.sp, color: Color(0xffBFBFBF)),
                      ),
                      onEditingComplete: () {
                        controller.tagAdvice = [];
                        controller.getTagAdvice(controller.tagComplement.text);
                      }),
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.only(left: 24, right: 24),
              height: 40.h,
              child: GetBuilder<CollectionSelectorCollector>(
                  id: 'changeTag',
                  builder: (_) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return singleTag(
                            controller.isCreate
                                ? controller.tagList[index]
                                : controller.collection.tagList[index],
                            false);
                      },
                      itemCount: controller.isCreate
                          ? controller.tagList.length
                          : controller.collection.tagList.length,
                    );
                  }),
            ),
            Container(
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
                        height: 16.h,
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
                        height: 16.h,
                        width: 16.w,
                        child: Checkbox(
                          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.w)),
                          value: (controller.isCreate
                                      ? controller.forbidComment
                                      : controller.collection.forbidComment) ==
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
                      controller.isCreate
                          ? controller.postNewCollection()
                          : controller.putEditCollection();
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
    );
  }

  Widget singleTag(TagList tagList, bool advice) {
    return Container(
      height: 16.h,
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(1.5),
          right: ScreenUtil().setWidth(1.5),
          top: ScreenUtil().setWidth(4)),
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
