import 'package:flutter/material.dart';
import 'package:sharemoe/controller/collection/collection_detail_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/ui/widget/sapp_bar.dart';
import 'package:sharemoe/ui/widget/water_flow/water_flow.dart';
import 'package:get/get.dart';

class CollectionDetailPage extends GetView<CollectionDetailController> {
  // final int collectionId;
  // final Collection collection;

  // CollectionDetailPage({Key key, this.collectionId, this.collection})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SappBar.collection(
        title: controller.collection.title,
      ),
      body: WaterFlow.collection(
        collectionId: controller.collection.id,
      ),
    );
  }
}
