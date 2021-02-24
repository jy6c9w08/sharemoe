import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ImageController extends GetxController with SingleGetTickerProviderMixin {
  AnimationController controller;

  @override
  void onInit() {
    controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    controller.forward();
    super.onInit();
  }

  @override
  void onClose() {
    controller.isCompleted == true ?? controller.dispose();
    super.onClose();
  }
}
