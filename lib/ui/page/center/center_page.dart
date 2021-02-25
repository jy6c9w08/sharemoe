import 'package:flutter/material.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';

class CenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar(title: '功能中心'),
      body: Center(
        child: Text('this is center page'),
      ),
    );
  }
}
