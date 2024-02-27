import 'package:flutter/material.dart';
import 'package:sharemoe/ui/page/pic/pic_page.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class SearchSimilarPage extends StatelessWidget {
  const SearchSimilarPage({Key? key, required this.tag}) : super(key: key);
final String tag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '以图搜图'),
      body: PicPage.similar(model: tag),
    );
  }
}
