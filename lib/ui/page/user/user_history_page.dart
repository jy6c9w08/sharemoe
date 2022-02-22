import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

import '../../widget/tab_view.dart';

class UserHistoryPage extends StatelessWidget {
  UserHistoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.normal(title: '历史记录'),
      body: TabView.history()
    );
  }
}
