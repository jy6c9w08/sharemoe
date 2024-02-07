import 'package:get/get.dart';

class ThemeController extends GetxController {
  bool isDark = Get.isDarkMode;

  updateThemeIcon() {
    update(['icon']);
  }
}
