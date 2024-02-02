// Flutter imports:
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/artist.dart';
import 'package:sharemoe/data/model/illust.dart';
import 'package:sharemoe/data/repository/user_repository.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ImageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late Illust illust;
  Artist? artist;
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();

  final isSelector = Rx<bool>(false);

  ImageController({required this.illust});

  late AnimationController imageLoadAnimationController;
  late bool isAlready = false;
  late bool isFired = false;
  late bool allowDisplay;

  @override
  void onInit() {
    imageLoadAnimationController = AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
        lowerBound: 0.2,
        upperBound: 1.0);
    allowDisplay = userService.r16FromHive()!;
    // getIt<PostImageIdService>().sendId(illust.id);
    super.onInit();
  }

  Future<bool> markIllust(bool isLiked) async {
    illust.isLiked = !illust.isLiked!;
    Map<String, String> body = {
      'userId': userService.userInfo()!.id.toString(),
      'illustId': illust.id.toString(),
      'username': userService.userInfo()!.username
    };
    if (isLiked) {
      userRepository.queryUserCancelMarkIllust(body).catchError((onError) {
        print(onError);
        illust.isLiked = true;
        update(['mark']);
      });
    } else {
      userRepository.queryUserMarkIllust(body).catchError((onError) {
        illust.isLiked = false;
        update(['mark']);
      });
    }

    update(['mark']);
    return illust.isLiked!;
  }

  openIllustDetail() async {
    String url = 'https://pixiv.net/artworks/${illust.id}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
    Get.back();
  }

  openArtistDetail() async {
    String url = 'https://pixiv.net/users/${illust.artistId}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
    Get.back();
  }

  jumpToAd() async {
    if (await canLaunchUrlString(illust.link!)) {
      await launchUrlString(illust.link!);
    } else {
      BotToast.showSimpleNotification(title: '唤起网页失败');
      throw 'Could not launch ${illust.link!}';
    }
  }

  copyIllustId() {
    Clipboard.setData(ClipboardData(text: illust.id.toString()));
    BotToast.showSimpleNotification(
        title: TextZhPicDetailPage.alreadyCopied, hideCloseButton: true);
    Get.back();
  }

  copyArtistId() {
    Clipboard.setData(ClipboardData(text: illust.artistId.toString()));
    BotToast.showSimpleNotification(
        title: TextZhPicDetailPage.alreadyCopied, hideCloseButton: true);
    Get.back();
  }

  @override
  void onClose() {
    imageLoadAnimationController.dispose();
    super.onClose();
  }
}
