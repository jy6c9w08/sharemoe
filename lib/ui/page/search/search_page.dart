// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/ui/page/search/everyone_search.dart';
import 'package:sharemoe/ui/page/search/suggestion_bar.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';

class SearchPage extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.search(),
      body: GetX<SearchController>(builder: (_) {
        return Center(
            child: controller.currentOnLoading.value
                ? EveryoneSearch()
                : Container(
                    // height: 500,
                    child: Column(
                      children: [
                        SuggestionBar(),
                        Expanded(child: TabView.search())
                      ],
                    ),
                  ));
      }),
    );
  }
}
