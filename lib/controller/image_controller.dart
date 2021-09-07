// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class ImageController extends GetxController with SingleGetTickerProviderMixin {
  final Illust illust;
  Artist? artist;
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();

  final isSelector = Rx<bool>(false);

  ImageController({required this.illust, illustId});

  late AnimationController imageLoadAnimationController;
  late bool isAlready = false;
  late bool isFired=false;
  late bool allowDisplay;

  @override
  void onInit() {
    imageLoadAnimationController = AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
        lowerBound: 0.2,
        upperBound: 1.0);
    allowDisplay=  userService.r16FromHive()!;
    super.onInit();
  }

  Future<bool> markIllust(bool isLiked) async {
    Map<String, String> body = {
      'userId': userService.userInfo()!.id.toString(),
      'illustId': illust.id.toString(),
      'username': userService.userInfo()!.username
    };
    if (isLiked) {
      await userRepository.queryUserCancelMarkIllust(body);
    } else {
      await userRepository.queryUserMarkIllust(body);
    }
    illust.isLiked = !illust.isLiked!;
    update(['mark']);
    return !isLiked;
  }

  openIllustDetail() async {
    String url = 'https://pixiv.net/artworks/${illust.id}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    Get.back();
  }

  openArtistDetail() async {
    String url = 'https://pixiv.net/users/${illust.artistId}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    Get.back();
  }

  copyIllustId() {
    Clipboard.setData(ClipboardData(text: illust.id.toString()));
    BotToast.showSimpleNotification(title: TextZhPicDetailPage.alreadyCopied);
    Get.back();
  }

  copyArtistId() {
    Clipboard.setData(ClipboardData(text: illust.artistId.toString()));
    BotToast.showSimpleNotification(title: TextZhPicDetailPage.alreadyCopied);
    Get.back();
  }

  @override
  void onClose() {
    imageLoadAnimationController.dispose();
    super.onClose();
  }
}
