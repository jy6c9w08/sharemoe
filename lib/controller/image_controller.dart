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
  // use colorAnimationController.forward() to like a image
  final favoriteColor = ColorTween(begin: Colors.grey, end: Colors.red);
  late AnimationController imageLoadAnimationController;
  late AnimationController colorAnimationController;
  late CurvedAnimation colorCurveAnimationController;
  late Animation colorAnimation;
  ImageController({required this.illust, illustId});

  @override
  void onInit() {
    imageLoadAnimationController = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    colorAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    colorCurveAnimationController = CurvedAnimation(
        parent: colorAnimationController, curve: Curves.fastLinearToSlowEaseIn);
    colorAnimation = favoriteColor.animate(colorCurveAnimationController);

    if (illust.isLiked == true) {
      colorAnimationController.forward();
      logger.i('init image color');
    }

    super.onInit();
  }

  markIllust() async {
    Map<String, String> body = {
      'userId': AuthBox().id.toString(),
      'illustId': illust.id.toString(),
      'username': AuthBox().name
    };
    if (illust.isLiked!) {
      await getIt<UserRepository>().queryUserCancelMarkIllust(body);
    } else {
      await getIt<UserRepository>().queryUserMarkIllust(body);
    }

    // change the color offavorite heart
    if (illust.isLiked == false) {
      colorAnimationController.forward();
    } else {
      colorAnimationController.reverse();
    }

    illust.isLiked = !illust.isLiked!;

    update(['mark']);
  }

  @override
  void onClose() {
    imageLoadAnimationController.dispose();
    super.onClose();
  }
}
