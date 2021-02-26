import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/page/search/everyone_search.dart';
import 'package:sharemoe/ui/widget/water_flow/water_flow.dart';

class SearchPage extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.search(),
      body: GetX<SearchController>(
        builder: (_) {
          return Center(
            child: controller.currentOnLoading.value
                ? EveryoneSearch()
                : WaterFlow.search(searchWords: controller.searchKeywords),
          );
        }
      ),
    );
  }
}
