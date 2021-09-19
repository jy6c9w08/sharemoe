// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/constant/event_type.dart';
import 'package:sharemoe/basic/domain/event.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/repository/vip_repository.dart';

late String vipUrl;

@singleton
@preResolve
class PicUrlUtil {
  final UserService userService;
  final VIPRepository vipRepository;
  final EventBus eventBus;
  late String? _vipPre=null;

  PicUrlUtil(this.userService, this.eventBus, this.vipRepository);

  @factoryMethod
  static Future<PicUrlUtil> create(UserService userService,
      VIPRepository vipRepository, Logger logger, EventBus eventBus) async {
    logger.i("图片url工具类开始初始化");
    PicUrlUtil picUrlUtil =
        new PicUrlUtil(userService, eventBus, vipRepository);
    //初始化vip前缀与普通用户前缀
    await picUrlUtil._init();
    picUrlUtil.registerToBus();
    getIt<EventBus>().fire(new Event(EventType.signOut, null));
    logger.i("图片url工具类初始化完毕");
    return picUrlUtil;
  }

  Future<void> _init() async {
      if(UserService.token != null){
        try {
        _vipPre = await vipRepository
            .queryGetHighSpeedServer()
            .then((value) => value[0].serverAddress);
        } catch (e) {

        }
      }

  }


  Future<void> getVIPAddress() async {
    if(UserService.token != null){
      _vipPre = await vipRepository
          .queryGetHighSpeedServer()
          .then((value) => value[0].serverAddress);
    }

  }

  void registerToBus() {
    eventBus.on<Event>().listen((event) async {
      switch(event.eventType){
        case  EventType.signOut:
        case  EventType.signIn:await _init(); break;
        case  EventType.signOutByExpire:await _init(); break;
      }
    });
  }

  String dealUrl(String originalUrl, String imageUrlLevel) {
    //vip
    if (userService.isLogin() &&
        userService.userInfo() != null &&
        userService.userInfo()!.permissionLevel > 2&&_vipPre!=null) {
      if (imageUrlLevel == ImageUrlLevel.original) {
        return originalUrl.replaceAll('https://i.pximg.net', _vipPre!) +
            '?Authorization=${userService.queryTokenByMem()}';
      } else {
        return originalUrl.replaceAll(
            'https://i.pximg.net', _vipPre!);
      }
      //普通用户
    } else {
      if (imageUrlLevel == ImageUrlLevel.original) {
        return originalUrl.replaceAll(
            'https://i.pximg.net', 'https://o.acgpic.net');
      } else {
        return originalUrl.replaceAll(
            'https://i.pximg.net', 'https://acgpic.net');
      }
    }
  }


}
