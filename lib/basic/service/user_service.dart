// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/basic/constant/event_type.dart';
import 'package:sharemoe/basic/domain/event.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

import 'package:logger/logger.dart'; // Project imports:

@singleton
@preResolve
class UserService {
  UserInfo? _userInfo;
  static late bool _isLogin;
  late Logger logger;
  late Box _picBox;
  late EventBus eventBus;
  late UserBaseRepository userBaseRepository;
  static String? token;

  UserService(Box _picBox, EventBus eventBus,UserBaseRepository userBaseRepository) {
    this._picBox = _picBox;
    this.eventBus = eventBus;
    this.userBaseRepository=userBaseRepository;
  }

  @factoryMethod
  static Future<UserService> create(Logger logger,
      UserBaseRepository userBaseRepository, Box box, EventBus eventBus) async {
    logger.i("用户服务开始初始化");
    UserService userService = new UserService(box, eventBus,userBaseRepository);
    userService._init();
    /// 是否需要? 不管是否登录都会从网络获取用户信息
    //查看hive中是否有数据 如果有则说明登陆过 则尝试获取用户信息（调用api）
    // UserInfo? userInfo = userService.userInfoFromHive();
    userService.keyBoardHeightFromHive() ??
        userService.setKeyBoardHeight(260.0);
    userService.themeModelFromHive()??userService.setThemeModel(ThemeMode.system);
    // print(userService.themeModelFromHive());
    userService.spareKeyboardFromHive() ?? userService.setSpareKeyboard(false);
    userService.waterNumberFromHive() ?? userService.setWaterNumber(2);
    userService.r16FromHive() ?? userService.setR16(false);
    logger.i("用户服务初始化完毕，用户登陆状态为：${userService.isLogin()}");
    return userService;
  }

  Future<void> _init() async {
    //尝试从hive中读取用户信息
    _userInfo = _picBox.get("userInfo");
    //尝试从hive中读取token
    token = _picBox.get("token");
    _isLogin = false;
  }

  //初始化（登陆）
  Future<void> signIn(UserInfo userInfo) async {
    await updateUserInfo(userInfo);
    _isLogin = true;
    eventBus.fire(new Event(EventType.signIn, null));
  }

  //更新用户信息
  Future<void> updateUserInfo(UserInfo userInfo) async {
    this._userInfo = userInfo;
    await _picBox.put("userInfo", userInfo);
  }
  //清除用户信息
  Future<void> deleteUserInfo()async {
    _picBox.delete("userInfo");
    _userInfo = null;
  }

  //登出
  void signOutByUser() {
    _picBox.delete("userInfo");
    _picBox.delete("token");
    _isLogin = false;
    _userInfo = null;
    token = null;
    eventBus.fire(new Event(EventType.signOut, null));
  }

//token过期
  static Future<void> signOutByTokenExpired() async {
    token = null;
    _isLogin = false;
    Box box = await Hive.openBox("picBox");
    box.put("token", null);
  }

//获取登陆状态
  bool isLogin() {
    if (token == null) {
      return false;
    } else {
      return _isLogin;
    }
  }

//获取用户信息
  UserInfo? userInfo() {
    return _userInfo;
  }

  int waterNumber() {
    return waterNumberFromHive()!;
  }

  bool spareKeyboard() {
    return spareKeyboardFromHive()!;
  }

   Future<UserInfo?>  userInfoFromInternet() async {
      return await userBaseRepository.queryUserInfo(_userInfo!.id);
  }
  UserInfo? userInfoFromHive() {
    return _picBox.get("userInfo");
  }

  double? keyBoardHeightFromHive() {
    return _picBox.get("keyBoardHeight");
  }

  bool? r16FromHive() {
    return _picBox.get("R16");
  }

  ThemeMode? themeModelFromHive(){
    print(_picBox.get("themeMode"));
    return _picBox.get("themeMode");
  }

  bool? spareKeyboardFromHive() {
    return _picBox.get("spareKeyboard");
  }

  int? waterNumberFromHive() {
    return _picBox.get("waterNumber");
  }

  setKeyBoardHeight(double height) {
    return _picBox.put("keyBoardHeight", height);
  }

  setSpareKeyboard(bool spareKeyboard) {
    _picBox.put('spareKeyboard', spareKeyboard);
  }

  setR16(bool r16) {
    _picBox.put('R16', r16);
  }

  setWaterNumber(int number) {
    _picBox.put('waterNumber', number);
  }

  setThemeModel(ThemeMode themeModel){
    _picBox.put('themeMode', themeModel);
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
    return box.get("token") ?? '';
  }

//从内存中获取token
  String? queryTokenByMem() {
    return token;
  }
}
