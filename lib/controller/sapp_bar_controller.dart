// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SappBarController extends GetxController {
  final ScreenUtil screen = ScreenUtil();
  final title = Rx<String>('');
  final searchBarHeight = Rx<double>(0.0);

  late TextEditingController searchTextEditingController;
  late FocusNode searchFocusNode;

  @override
  void onInit() {
    title.value = '日排行';
    super.onInit();
  }

  void initSearchBar() {
    searchBarHeight.value = screen.setHeight(35);
    searchTextEditingController = TextEditingController();
    searchFocusNode = FocusNode()..addListener(searchFocusNodeListener);
  }

  void searchFocusNodeListener() {
    print('searchFocusNodeListener is Lisetning');
    print(
        'Search TextEdit FocusNode: ${searchFocusNode.hasFocus}'); // https://stackoverflow.com/questions/54428029/flutter-how-to-clear-text-field-on-focus
    if (searchFocusNode.hasFocus == false) {
//      setState(() {
      searchBarHeight.value = screen.setHeight(35);
//      });
    } else {
//      setState(() {
      searchBarHeight.value = ScreenUtil().setHeight(77);
//      });
    }
  }


}
