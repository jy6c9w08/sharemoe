import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:intl/intl.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';

import 'package:sharemoe/data/model/search.dart';
import 'package:sharemoe/data/repository/search_repository.dart';

class SearchController extends GetxController {
  final hotSearchList = Rx<List<HotSearch>>();
  final String _picDateStr = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(Duration(days: 3)));
  final currentOnLoading = Rx<bool>();
  String searchKeywords;

  @override
  void onInit() {
    currentOnLoading.value = true;
    getList().then((value) => hotSearchList.value = value);
    super.onInit();
  }

  Future<List<HotSearch>> getList() async {
    return await getIt<SearchRepository>()
        .queryHotSearchTags(_picDateStr)
        .then((value) => value);
  }
}
