import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/ui/widget/water_flow/water_flow.dart';

class BookMarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(picBox.get('id').toString());
    return WaterFlow.bookmark(
      userId: picBox.get('id').toString(),
    );
  }
}
