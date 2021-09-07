import 'package:get/get.dart';

// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

class DiscussionController extends GetxController {
  Rx<bool> finish = Rx<bool>(false);

  // late WebViewController webViewController;

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

  @override
  void onInit() async {
    super.onInit();
  }
}
