// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/event_type.dart';
import 'package:sharemoe/basic/domain/event.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/repository/app_repository.dart';
import 'package:sharemoe/data/repository/vip_repository.dart';

import '../../data/model/image_url_pre.dart';
import '../../data/repository/app_repository.dart';

late String vipUrl;

@singleton
@preResolve
class PicUrlUtil {
  final UserService userService;
  final VIPRepository vipRepository;
  final AppRepository appRepository;
  final EventBus eventBus;
  late String? _vipPre;
  late ImageUrlPre? _imageUrlPre;

  PicUrlUtil(
      this.userService, this.eventBus, this.vipRepository, this.appRepository);

  @factoryMethod
  static Future<PicUrlUtil> create(
      UserService userService,
      VIPRepository vipRepository,
      Logger logger,
      EventBus eventBus,
      AppRepository appRepository) async {
    logger.i("图片url工具类开始初始化");
    PicUrlUtil picUrlUtil =
        new PicUrlUtil(userService, eventBus, vipRepository, appRepository);
    //初始化vip前缀与普通用户前缀
    await picUrlUtil._init();
    picUrlUtil.registerToBus();
    getIt<EventBus>().fire(new Event(EventType.signOut, null));
    logger.i("图片url工具类初始化完毕");
    return picUrlUtil;
  }

  Future<void> _init() async {
    if (UserService.token != null) {
      //可直接调用或者在PicUrlUtil加个AppRepository调用
      // await getIt<AppRepository>()
      //     .queryImageUrlPre()
      //     .then((value) => print(value.original));
      try {
        _vipPre = await vipRepository
            .queryGetHighSpeedServer()
            .then((value) => value[0].serverAddress);
        _imageUrlPre = await appRepository.queryImageUrlPre();
      } catch (e) {
        _vipPre = null;
      }
    }
  }

  Future<void> getVIPAddress() async {
    if (UserService.token != null) {
      _vipPre = await vipRepository
          .queryGetHighSpeedServer()
          .then((value) => value[0].serverAddress);
    }
  }

  void registerToBus() {
    eventBus.on<Event>().listen((event) async {
      switch (event.eventType) {
        case EventType.signOut:
          break;
        case EventType.signIn:
          await _init().then((value) =>
              Get.find<WaterFlowController>(tag: 'home').refreshIllustList());
          break;
        case EventType.signOutByExpire:
          await _init();
          break;
      }
    });
  }

  String dealUrl(String originalUrl, String imageUrlLevel) {
    //vip
    if (userService.isLogin() &&
        userService.userInfo() != null &&
        userService.userInfo()!.permissionLevel > 2 &&
        _vipPre != null) {
      if (imageUrlLevel == ImageUrlLevel.original) {
        return originalUrl.replaceAll('https://i.pximg.net', _vipPre!) +
            '?Authorization=${userService.queryTokenByMem()}';
      } else {
        return originalUrl.replaceAll('https://i.pximg.net', _imageUrlPre!.smallCn);
      }
      //普通用户
    } else {
      if (imageUrlLevel == ImageUrlLevel.original) {
        return originalUrl.replaceAll(
            'https://i.pximg.net', _imageUrlPre!.original);
      } else {
        return originalUrl.replaceAll(
            'https://i.pximg.net', _imageUrlPre!.smallCn);
      }
    }
  }
}
