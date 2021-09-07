// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

class GlobalController extends GetxController {
  final isLogin = Rx<bool>(false);
  static final UserService userService = getIt<UserService>();
  late String time;

  late CookieManager cookieManager = CookieManager.instance();
  late Cookie? cookie = Cookie(name: '', value: '');

// set the expiration date for the cookie in milliseconds
  final expiresDate =
      DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch;
  final url = Uri.parse("https://discuss.sharemoe.net/");

// set the cookie
  Future setCookie() async {
    await cookieManager.setCookie(
      url: url,
      name: "flarum_remember",
      value: await getIt<UserBaseRepository>().queryDiscussionToken(),
      domain: ".discuss.sharemoe.net",
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

  @override
  void onInit() {
    //打开应用时间
    time = DateTime.now().millisecondsSinceEpoch.toString();
    checkLogin();
    super.onInit();
  }
}
