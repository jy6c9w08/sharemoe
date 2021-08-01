// Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

@singleton
@preResolve
class UserService {
  late UserInfo? _userInfo;
  static late  bool _isLogin;
  late Logger logger;
  late Box _picBox;
  static  String? token;

  UserService(Box _picBox){
    this._picBox=_picBox;
  }

  @factoryMethod
  static Future<UserService> create(Logger logger,UserBaseRepository userBaseRepository,Box box)  async {
    logger.i("用户服务开始初始化");
    UserService userService = new UserService(box);
    userService._init();
    //查看hive中是否有数据 如果有则说明登陆过 则尝试获取用户信息（调用api）
    UserInfo? userInfo=userService.userInfoFromHive();
    if(userInfo!=null){
      UserInfo newUserInfo= await userBaseRepository.queryUserInfo(userInfo.id);
      logger.i("检测到用户已经登陆过，开始尝试拉取更新本地用户信息");
        await userService.signIn(newUserInfo);
    }
    logger.i("用户服务初始化完毕，用户登陆状态为：${userService.isLogin()}");
    return userService;
  }

  Future<void> _init() async {
    //尝试从hive中读取用户信息
    _userInfo=_picBox.get("userInfo" );
    //尝试从hive中读取token
    token=_picBox.get("token" );
    _isLogin=false;
  }


  //初始化（登陆）
  Future<void> signIn(UserInfo userInfo) async {
    await updateUserInfo(userInfo);
    _isLogin = true;
  }

  //更新用户信息
  Future<void> updateUserInfo(UserInfo userInfo) async {
    this._userInfo=userInfo;
    await _picBox.put("userInfo", userInfo);
  }

  //登出
  void signOutByUser() {
    _picBox.delete("userInfo");
    _picBox.delete("token");
    _isLogin = false;
    _userInfo=null;
    token=null;
  }

//token过期
  static void signOutByTokenExpired() {
    token=null;
    _isLogin = false;
  }

//获取登陆状态
  bool isLogin() {
    if(token==null){
      return false;
     }else{
      return _isLogin;
    }
  }

//获取用户信息
  UserInfo? userInfo() {
    return _userInfo;
  }

  UserInfo? userInfoFromHive() {
    return _picBox.get("userInfo");
  }


//设置token
  static Future<void> setToken(String newToken) async {
    Box box = await Hive.openBox("picBox");
    token = newToken;
    box.put("token", newToken);
  }

//获取token
  static Future<String> queryToken() async {
    Box box = await Hive.openBox("picBox");
    return box.get("token")??'';
  }
//从内存中获取token
  String queryTokenByMem()  {
   return token!;
  }
}

