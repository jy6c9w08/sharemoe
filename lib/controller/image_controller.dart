import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class ImageController extends GetxController with SingleGetTickerProviderMixin {
  // bool isLiked = false;
  final Illust illust;
  final isSelector = Rx<bool>(false);

  late AnimationController controller;

  ImageController({required this.illust, illustId});

  @override
  void onInit() {
    controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    super.onInit();
  }

  markIllust() async {
    Map<String, String> body = {
      'userId':PicBox().id.toString(),
      'illustId': illust.id.toString(),
      'username': PicBox().name
    };
    if (illust.isLiked!) {
      await getIt<UserRepository>().queryUserCancelMarkIllust(body);
    } else {
      await getIt<UserRepository>().queryUserMarkIllust(body);
    }

    illust.isLiked = !illust.isLiked!;

    update(['mark']);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
