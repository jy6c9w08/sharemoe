import 'package:get/get.dart';

import 'package:sharemoe/ui/page/home/home_page.dart';

part './app_routes.dart';
class AppPages{
  static final pages=[
    GetPage(name: Routes.HOME,page: ()=>HomePage())
  ];
}