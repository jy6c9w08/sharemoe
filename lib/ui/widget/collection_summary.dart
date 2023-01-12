import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/controller/collection/collection_summary_controller.dart';
import 'package:sharemoe/routes/app_pages.dart';
import 'package:sharemoe/ui/widget/state_box.dart';

class CollectionSummaryDialog extends GetView<CollectionSummaryController> {
  CollectionSummaryDialog({
    Key? key,
    this.illustId,
  }) : super(key: key);
  final int? illustId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CollectionSummaryController(),
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
            content: controller.obx(
                (state) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            padding: EdgeInsets.only(bottom: 5.h),
                            alignment: Alignment.center,
                            child: Text(
                              TextZhPicDetailPage.addToCollection,
                              style: TextStyle(color: Colors.orangeAccent),
                            )),
                        Container(
                          constraints: BoxConstraints(maxHeight: 200.h),
                          child: SingleChildScrollView(
                            child: Column(
                              children: controller.collectionSummary
                                  .map((item) => ListTile(
                                        title: Text(item.title),
                                        onTap: () {
                                          controller.addIllustToCollection(
                                              item.id,
                                              illustList: illustId == null
                                                  ? null
                                                  : [illustId!]);
                                        },
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        Container(
                            width: 100.w,
                            padding: EdgeInsets.only(top: 8.h),
                            child: TextButton(
                                child: Icon(Icons.add),
                                onPressed: () {
                                  Get.toNamed(Routes.COLLECTION_CREATE_PUT,
                                      preventDuplicates: false);
                                })),
                      ],
                    ),
                onEmpty: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Lottie.asset('assets/image/empty-box.json',
                        repeat: false, height: ScreenUtil().setHeight(80)),
                    Container(
                      // width: screen.setWidth(300),
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(TextZhPicDetailPage.addFirstCollection),
                    ),
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.only(top: 8.h),
                      child: TextButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          Get.toNamed(Routes.COLLECTION_CREATE_PUT,
                              preventDuplicates: false);
                        },
                      ),
                    )
                  ],
                ),
            onLoading: Container(
              height: 150.h,
              child: LoadingBox(),
            )
            ),
          );
        });
  }
}
