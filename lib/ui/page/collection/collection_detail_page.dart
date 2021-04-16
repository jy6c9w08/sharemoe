import 'package:flutter/material.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/water_flow/water_flow.dart';

class CollectionDetailPage extends StatelessWidget {
  final int collectionId;
  final String title;

  CollectionDetailPage({Key key, this.collectionId, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.collection(
        title: title,
      ),
      body: WaterFlow.collection(
        collectionId: collectionId,
      ),
    );
  }
}
