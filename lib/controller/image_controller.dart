import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/basic/config/logger_config.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/user_repository.dart';


class ImageController extends GetxController with SingleGetTickerProviderMixin {
  // bool isLiked = false;
  final Illust illust;

  final isSelector = Rx<bool>(false);
  ImageController({required this.illust, illustId});
  late AnimationController imageLoadAnimationController;
  @override
  void onInit() {
    imageLoadAnimationController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );

    super.onInit();
  }

  Future<bool> markIllust(bool isLiked) async {
    Map<String, String> body = {
      'userId': AuthBox().id.toString(),
      'illustId': illust.id.toString(),
      'username': AuthBox().name
    };
    if (isLiked) {
      await getIt<UserRepository>().queryUserCancelMarkIllust(body);
    } else {
      await getIt<UserRepository>().queryUserMarkIllust(body);
    }
    illust.isLiked = !illust.isLiked!;
    update(['mark']);
    return !isLiked;
  }

  @override
  void onClose() {
    imageLoadAnimationController.dispose();
    super.onClose();
  }
}
