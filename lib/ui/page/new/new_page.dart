import 'package:flutter/material.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SappBar(title: '画师更新',),
        body: Center(child: Text('this is new page')));
  }
}
