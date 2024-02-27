// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/controller/search_controller.dart'as SharemoeSearch;
import 'package:sharemoe/ui/page/search/everyone_search.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/tab_view.dart';

class SearchPage extends GetView<SharemoeSearch.SearchController> {
  @override
  final String tag;

  SearchPage({required this.tag});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.search(tag: tag,),
      body: GetX<SharemoeSearch.SearchController>(
          tag: tag,
          builder: (_) {
        return Center(
            child: controller.currentOnLoading.value
                ? EveryoneSearch(tag)
                : TabView.search(searchKeywords:tag,));
      }),
    );
  }
}
