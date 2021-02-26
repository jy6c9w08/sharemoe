import 'package:flutter/material.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

import '../../widget/water_flow/water_flow.dart';

class PicPage extends StatefulWidget {
  @override
  _PicPageState createState() => _PicPageState();
}

class _PicPageState extends State<PicPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: SappBar.home(),
      body: WaterFlow.home(),
    );
  }
}
