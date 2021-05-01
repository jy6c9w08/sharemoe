import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/controller/collection/collection_controller.dart';
import 'package:sharemoe/data/model/collection.dart';
import 'package:sharemoe/data/repository/collection_repository.dart';
import 'package:flutter/material.dart';

import 'collection_selector_controller.dart';

class CollectionDetailController extends GetxController {
  final int index = Get.arguments;
  Collection collection;
  List<TagList> tagAdvice = [];

  // final collection=Rx<Collection>();
  int currentPage;

  TextEditingController title;
  TextEditingController caption;
  TextEditingController tagComplement;

  CollectionDetailController();

  @override
  void onInit() {
    collection = Get.find<CollectionController>().collectionList.value[index];
    title = TextEditingController(text: collection.title);
    caption = TextEditingController(text: collection.caption);
    tagComplement = TextEditingController();
   Get.find<CollectionSelectorCollector>().selectMode=false;
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

  updateTitle() {
    collection.title = title.text;
    collection.caption = caption.text;
    update(['title']);
    Get.find<CollectionController>().updateTitle(title.text,collection.tagList, index);
  }

  getTagAdvice() async {
    tagAdvice = tagAdvice +
        await getIt<CollectionRepository>()
            .queryTagComplement(tagComplement.text);
    update(['tagComplement']);
  }

  addTagToTagsList(TagList tagList) {
    if (!collection.tagList.contains(tagList)) collection.tagList.add(tagList);
    update(['changeTag']);
  }

  removeTagFromTagsList(TagList tagList) {
    collection.tagList
        .removeWhere((element) => element.tagName == tagList.tagName);
    update(['changeTag']);
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
        updateTitle();
        Get.back();
      });
    }
  }

  @override
  void onClose() {
    Get.find<CollectionSelectorCollector>().selectMode=true;
  }
}
