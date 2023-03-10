// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/upgrade_service.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/app_info.dart';
import 'package:sharemoe/data/repository/app_repository.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);
  static final UserService userService = getIt<UserService>();
  static final UpgradeService upgradeService = getIt<UpgradeService>();
  final time = Rx<String>('');

  late CookieManager cookieManager = CookieManager.instance();
  late Cookie? cookie = Cookie(name: '', value: '');

// set the expiration date for the cookie in milliseconds
  final expiresDate =
      DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch;
  final url = Uri.parse("https://d.edcms.pw/");

// set the cookie
  Future setCookie() async {
    await cookieManager.setCookie(
      url: url,
      name: "flarum_remember",
      value: await getIt<UserBaseRepository>().queryDiscussionToken(),
      domain: ".d.edcms.pw",
      expiresDate: expiresDate,
      isSecure: true,
    );
    cookie = await cookieManager.getCookie(url: url, name: "myCookie");
  }

  checkLogin() {
    if (userService.isLogin()) {
      isLogin.value = true;
      setCookie();
    } else {
      isLogin.value = false;
      // if (AuthBox().permissionLevel > 2)
      //   getIt<VIPRepository>()
      //       .queryGetHighSpeedServer()
      //       .then((value) => vipUrl = value[1].serverAddress);
    }
  }

  checkVersion(bool fromAboutPage) async {
    APPInfo? appInfo;
    try {
      if (GetPlatform.isIOS || GetPlatform.isMacOS)
        appInfo = await getIt<AppRepository>()
            .queryUpdateInfo(upgradeService.appInfo().version, 'ios');
      else
        appInfo = await getIt<AppRepository>()
            .queryUpdateInfo(upgradeService.appInfo().version, 'android');
    } catch (e) {}
    if (appInfo != null && !upgradeService.downloading)
      return haveNewVersionDialog(appInfo);
    else if (upgradeService.downloading && GetPlatform.isAndroid)
      return upgradeDialog();
    else if (fromAboutPage)
      return BotToast.showSimpleNotification(
          title: '???????????????', hideCloseButton: true);
  }

  haveNewVersionDialog(APPInfo appInfo) {
    Get.dialog(AlertDialog(
      contentPadding: EdgeInsets.only(top: 4.h),
      titlePadding: EdgeInsets.only(top: 8.h, left: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '???????????????',
            style: TextStyle(color: Color(0xffF2994A), fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            'ShareMoe V' + appInfo.version,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Html(
              data: appInfo.updateLog,
              shrinkWrap: true,
              style: {
                "body": Style(
                  fontSize: FontSize(12.sp),
                ),
              },
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('????????????',
                    style:
                        TextStyle(fontSize: 14.sp, color: Color(0xff868B92)))),
            TextButton(
                onPressed: () {
                  if (!upgradeService.downloading)
                    upgradeService.upgrade(appInfo.androidLink);

                  Get.back();

                  if (GetPlatform.isAndroid) upgradeDialog();
                },
                child: Text('????????????',
                    style:
                        TextStyle(fontSize: 14.sp, color: Color(0xff2F80ED))))
          ],
        )
      ],
    ));
  }

  upgradeDialog() {
    Get.dialog(AlertDialog(
      contentPadding: EdgeInsets.only(top: 4.h),
      titlePadding: EdgeInsets.only(top: 8.h, left: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '?????????',
            style: TextStyle(color: Color(0xffF2994A), fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            'ShareMoe',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Lottie.asset('assets/image/download.json'),
          Positioned(
            bottom: 60.h,
            child: Obx(() {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Color(0xff6C83FC)),
                alignment: Alignment.center,
                height: 16.h,
                width: getIt<UpgradeService>().downloadPercent.value.w,
                child: Text(
                  getIt<UpgradeService>().downloadPercent.value.toString(),
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () {
                  upgradeService.token.cancel();
                  Get.back();
                },
                child: Text('????????????',
                    style:
                        TextStyle(fontSize: 14.sp, color: Color(0xff868B92)))),
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('????????????',
                    style:
                        TextStyle(fontSize: 14.sp, color: Color(0xff2F80ED))))
          ],
        )
      ],
    ));
  }

  @override
  void onInit() {
    //??????????????????
    time.value = DateTime.now().millisecondsSinceEpoch.toString();
    checkLogin();
    Future.delayed(Duration(seconds: 2)).then((value) => checkVersion(false));
    super.onInit();
  }
}
