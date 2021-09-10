import 'package:flutter/material.dart';
import 'package:sharemoe/controller/collection/collection_selector_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:get/get.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateCollectionPage extends GetView<CollectionSelectorCollector> {
  const CreateCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '画集'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            child: ExtendedImage.asset(
              'assets/image/background.png',
              fit: BoxFit.cover,
              height: 94.h,
              width: 1.sw,
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.only(left: 16.w),
            child: Text(
              '新建个人画集',
              style: TextStyle(
                  fontSize: 22.sp,
                  color: Color(0xffF7AF2B),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.only(left: 16.w),
            child: Text(
              '画集标题',
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xff515151),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: controller.title,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 11.h, bottom: 2.h),
                hintText: '在此输入画集的标题',
                hintStyle: TextStyle(fontSize: 10.sp, color: Color(0xffBFBFBF)),
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            padding: EdgeInsets.only(left: 16.w),
            child: Text(
              '画集简介',
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xff515151),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: controller.caption,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 11.h, bottom: 2.h),
                hintText: '介绍你的画集主题、内容和想法',
                hintStyle: TextStyle(fontSize: 10.sp, color: Color(0xffBFBFBF)),
              ),
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            padding: EdgeInsets.only(left: 16.w),
            child: Text(
              '画集标签',
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xff515151),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
                controller: controller.tagComplement,
                decoration: InputDecoration(
                  suffix: InkWell(
                    onTap: () {
                      controller.tagAdvice = [];
                      controller.getTagAdvice(controller.tagComplement.text);
                    },
                    child: SvgPicture.asset(
                      'assets/icon/search.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.only(top: 6.h, bottom: 2.h),
                  // contentPadding: EdgeInsets.a,
                  hintText: '搜索标签并选择，至多添加5个标签',
                  hintStyle:
                      TextStyle(fontSize: 10.sp, color: Color(0xffBFBFBF)),
                ),
                onEditingComplete: () {
                  controller.tagAdvice = [];
                  controller.getTagAdvice(controller.tagComplement.text);
                }),
          ),
          Container(
            padding: EdgeInsets.only(left: 24, right: 24),
            height: 40.h,
            child: GetBuilder<CollectionSelectorCollector>(
                id: 'changeTag',
                builder: (_) {
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return singleTag(controller.tagList[index], false);
                    },
                    itemCount: controller.tagList.length,
                  );
                }),
          ),
          Container(
            width: 276.w,
            height: 84.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
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
        ],
      ),
    );
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
