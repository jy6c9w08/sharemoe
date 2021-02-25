import 'package:get/get.dart';
import 'package:sharemoe/bindings/home_binding.dart';

import 'package:sharemoe/ui/page/home_page.dart';
import 'package:sharemoe/ui/page/sharemoe/sharemoe_page.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding())
  ];
}
