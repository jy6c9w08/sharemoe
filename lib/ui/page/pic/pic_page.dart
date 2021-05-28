import 'package:flutter/material.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:get/get.dart';

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
    // Get.put(WaterFlowController(tag: 'home'));
    super.build(context);
    return Scaffold(
      appBar: SappBar.home(),
      body: WaterFlow.home(),
    );
  }
}
