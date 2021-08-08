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
import 'package:sharemoe/data/repository/artist_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class ArtistDetailController extends GetxController {
  final Artist artist;

  // final int artistId;
  final ScrollController scrollController = ScrollController();
  static final ArtistRepository artistRepository = getIt<ArtistRepository>();
  static final UserService userService = getIt<UserService>();

  ArtistDetailController({required this.artist});

//关注
  follow() async {
    if (artist.isFollowed!) {
      Map<String, dynamic> body = {
        'artistId': artist.id!,
        'userId': userService.userInfo()!.id,
      };
      await getIt<UserRepository>().queryUserCancelMarkArtist(body);
      artist.isFollowed = !artist.isFollowed!;
      update(['follow']);
    } else {
      Map<String, dynamic> body = {
        'artistId': artist.id!,
        'username': userService.userInfo()!.username,
        'userId': userService.userInfo()!.id,
      };

      await getIt<UserRepository>().queryUserMarkArtist(body);
      artist.isFollowed = !artist.isFollowed!;
      update(['follow']);
    }
  }

  openTwitter()async{
    if (await canLaunch(artist.twitterUrl!)) {
      await launch(artist.twitterUrl!);
    } else {
      BotToast.showSimpleNotification(title: '唤起网页失败');
      throw 'Could not launch ${artist.twitterUrl!}';
    }
  }
  openWeb()async{
    if (await canLaunch(artist.webPage!)) {
      await launch(artist.webPage!);
    } else {
      BotToast.showSimpleNotification(title: '唤起网页失败');
      throw 'Could not launch ${artist.webPage!}';
    }
  }
  copyId(){
    Clipboard.setData(
        ClipboardData(text: artist.id.toString()));
    BotToast.showSimpleNotification(
        title: TextZhPicDetailPage.alreadyCopied);
  }

  @override
  onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
