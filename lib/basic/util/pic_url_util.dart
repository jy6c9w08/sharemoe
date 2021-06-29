import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sharemoe/basic/constant/ImageUrlLevel.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/repository/vip_repository.dart';

late String vipUrl;

@singleton
@preResolve
class PicUrlUtil {
  final UserService userService;
  late String? _vipPre;

  PicUrlUtil(this.userService);

  @factoryMethod
  static Future<PicUrlUtil> create(
      UserService userService, VIPRepository vipRepository,Logger logger) async {
    logger.i("图片url工具类开始初始化");
    PicUrlUtil picUrlUtil = new PicUrlUtil(userService);
    //初始化vip前缀
    if(userService.isLogin()&&userService.userInfo()!=null&&userService.userInfo()!.permissionLevel > 2){
      picUrlUtil._vipPre = await vipRepository
          .queryGetHighSpeedServer()
          .then((value) => value[0].serverAddress);
    }
    logger.i("图片url工具类初始化完毕");
    return picUrlUtil;
  }

  String dealUrl(String originalUrl, String imageUrlLevel) {
    //vip
    if (userService.isLogin() &&userService.userInfo()!=null&& userService.userInfo()!.permissionLevel > 2) {
      if(imageUrlLevel==ImageUrlLevel.original){
        return originalUrl.replaceAll('https://i.pximg.net', _vipPre!) +
            '?Authorization=${userService.queryTokenByMem()}';
      }else{
        return originalUrl.replaceAll('https://i.pximg.net', 'https://acgpic.net');
      }
      //普通用户
    }else {
      if(imageUrlLevel==ImageUrlLevel.original){
        return originalUrl.replaceAll('https://i.pximg.net', 'https://o.acgpic.net');
      }else{
        return originalUrl.replaceAll('https://i.pximg.net', 'https://acgpic.net');
      }
    }
  }
}
