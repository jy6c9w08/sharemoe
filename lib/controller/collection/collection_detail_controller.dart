import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:flutter/material.dart';

class CollectionDetailController extends GetxController {
  final Collection collection;

  // final collection=Rx<Collection>();
  int currentPage;

  TextEditingController title;
  TextEditingController caption;

  CollectionDetailController({this.collection});

  @override
  void onInit() {
    title = TextEditingController(text: collection.title);
    caption = TextEditingController(text: collection.caption);
    super.onInit();
  }

  switchPublic(int value) {
    collection.isPublic = value;
    update(['public']);
  }

  switchAllowComment(int value) {
    collection.forbidComment = value;
    update(['allowComment']);
  }

  switchPornWaring(int value) {
    collection.pornWarning = value;
    update(['pornWaring']);
  }

  updateTitle(String title) {
    collection.title = title;
    update(['title']);
  }

  putEditCollection() async {
    Map<String, dynamic> payload = {
      'id': collection.id,
      'username': picBox.get('name'),
      'title': title.text,
      'caption': caption.text,
      'isPublic': collection.isPublic,
      'pornWarning': collection.pornWarning,
      'forbidComment': collection.forbidComment,
      'tagList': collection.tagList
    };

    if (collection.tagList != null) {
      await getIt<CollectionRepository>()
          .queryUpdateCollection(collection.id, payload)
          .then((value) {
        updateTitle(title.text);
        Get.back();
      });
    }
  }

// getCollectionIllust({int currentPage = 1}) {
//   getIt<CollectionRepository>()
//       .queryViewCollectionIllust(collectionId, currentPage, 10);
// }
}
