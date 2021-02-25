import 'package:get/get.dart';

class SappBarController extends GetxController {

  final title = Rx<String>();
@override
  void onInit() {
   title.value='日排行';
    super.onInit();
  }
}
