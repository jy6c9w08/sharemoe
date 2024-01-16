// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/search_controller.dart' as SharemoeSearch;
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:bot_toast/bot_toast.dart';

class SappBarController extends GetxController {
  final ScreenUtil screen = ScreenUtil();
  final title = Rx<String>('');
  final searchBarHeight = Rx<double>(0.0);

  late TextEditingController searchTextEditingController;
  late FocusNode searchFocusNode;
  final DateTime picFirstDate = DateTime(2008, 1, 1);
  final DateTime picLastDate = DateTime.now().subtract(Duration(hours: 39));
  final DateTime initialDateRangeStart =
      DateTime.now().subtract(Duration(days: 5));
  final DateTime initialDateRangeEnd =
      DateTime.now().subtract(Duration(days: 2));
  String? dateStart;
  String? dateEnd;
  bool selectIllustType = true;
  bool selectMagaType = false;
  bool searchOriginalType = true;
  bool searchTranslateType = false;
  final TextEditingController minWidthTextController = TextEditingController();
  final TextEditingController minHeightTextController = TextEditingController();

  @override
  void onInit() {
    title.value = '日排行';
    initSearchBar();
    super.onInit();
  }

  void initSearchBar() {
    searchBarHeight.value = screen.setHeight(45);
    searchTextEditingController = TextEditingController();
    searchFocusNode = FocusNode()..addListener(searchFocusNodeListener);
  }

  switchIllustType(bool isIllust) {
    if (isIllust == true && !selectIllustType) {
      selectIllustType = true;
      selectMagaType = false;
    }
    update(['switchImageType']);
  }

  switchMagaType(bool isMage) {
    if (isMage == true && !selectMagaType) {
      selectMagaType = true;
      selectIllustType = false;
    }

    update(['switchImageType']);
  }

  switchOriginalType(bool isOriginal) {
    if (isOriginal == true && !searchOriginalType) {
      searchOriginalType = true;
      searchTranslateType = false;
    }

    update(['switchSearchType']);
  }

  switchTranslateType(bool isTranslate) {
    if (isTranslate == true && !selectMagaType) {
      searchTranslateType = true;
      searchOriginalType = false;
    }

    update(['switchSearchType']);
  }

  void searchFocusNodeListener() {
    print('searchFocusNodeListener is Lisetning');
    print(
        'Search TextEdit FocusNode: ${searchFocusNode.hasFocus}'); // https://stackoverflow.com/questions/54428029/flutter-how-to-clear-text-field-on-focus
    if (searchFocusNode.hasFocus == false) {
      searchBarHeight.value = screen.setHeight(45);
    } else {
      searchBarHeight.value = ScreenUtil().setHeight(87);
    }
  }

  selectRangeDate() async {
    DateTimeRange? _dateRangeTime =
        await _showRangeDatePickerForDay(Get.context!);
    if (_dateRangeTime == null) {
      print("取消选择");
    } else {
      dateStart = DateFormat('yyyy-MM-dd').format(_dateRangeTime.start);
      dateEnd = DateFormat('yyyy-MM-dd').format(_dateRangeTime.end);
      print(DateFormat('yyyy-MM-dd').format(_dateRangeTime.start));
      print("开始 ${_dateRangeTime.start}");
      print("结束 ${_dateRangeTime.end}");
    }
    update(['updateData']);
  }

  //范围时间选择器
  Future<DateTimeRange?> _showRangeDatePickerForDay(BuildContext context) {
    return showDateRangePicker(
      context: context,
      firstDate: picFirstDate,
      lastDate: picLastDate,
      initialDateRange:
          DateTimeRange(start: initialDateRangeStart, end: initialDateRangeEnd),
      // 初始时间范围
      currentDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      helpText: "请选择日期区间",
      cancelText: "取消",
      confirmText: "确定",
      saveText: "完成",
      errorFormatText: "输入格式有误",
      errorInvalidRangeText: "开始日期不可以在结束日期之后",
      errorInvalidText: "输入不合法",
      fieldStartHintText: "请输入开始日期",
      fieldEndHintText: "请输入结束日期",
      fieldStartLabelText: "开始日期",
      fieldEndLabelText: "结束日期",
      useRootNavigator: true,
      // textDirection: TextDirection.ltr,
    );
  }

  selectDate() async {
    WaterFlowController flowController =
        Get.find<WaterFlowController>(tag: 'home');
    DateTime? newDate = await showDatePicker(
      context: Get.context!,
      initialDate: flowController.picDate!,
      firstDate: picFirstDate,
      lastDate: picLastDate,
      // locale: Locale('zh'),
    );
    if (newDate != null && flowController.picDate != newDate) {
      flowController.refreshIllustList(picDate: newDate);
    }
  }

  //翻译搜索
  searchByTranslation(tag) {
    if (getIt<UserService>().userInfo()!.permissionLevel < 3)
      return BotToast.showSimpleNotification(
          title: '您不是会员哦', hideCloseButton: true);
    else
      return Get.find<SharemoeSearch.SearchController>(tag: tag)
          .transAndSearchTap(searchTextEditingController.text, tag);
  }

  //id搜画师
  searchArtistById(tag) {
    return Get.find<SharemoeSearch.SearchController>(tag: tag)
        .searchArtistById(int.parse(searchTextEditingController.text));
  }

  //id搜画作
  searchIllustById(tag) {
    return Get.find<SharemoeSearch.SearchController>(tag: tag)
        .searchIllustById(int.parse(searchTextEditingController.text));
  }

  //条件搜索按钮
  searchByCriteriaButton(String tag) {
    Get.find<WaterFlowController>(tag: tag)
      ..model = 'searchByCriteria'
      ..refreshIllustList(
          dateEnd: dateEnd,
          dateStart: dateStart,
          minWidth: minWidthTextController.text == ''
              ? null
              : int.parse(minWidthTextController.text),
          minHeight: minHeightTextController.text == ''
              ? null
              : int.parse(minHeightTextController.text),
          searchKeyword: searchTextEditingController.text,
          illustType: selectIllustType ? 'illust' : 'mage',
          searchType: searchOriginalType ? 'original' : 'autoTranslate',
          tag: tag);
    Get.back();
  }

  @override
  void onClose() {
    searchTextEditingController.dispose();
    searchFocusNode.removeListener(searchFocusNodeListener);
    searchFocusNode.dispose();
    super.onClose();
  }
}
