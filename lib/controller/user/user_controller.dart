import 'dart:io';
import 'dart:typed_data';
import 'package:image_editor/image_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:image_picker/image_picker.dart' as prefix;
import 'package:extended_image/extended_image.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

import '../global_controller.dart';

class UserController extends GetxController {
  final Rx<UserInfo> userInfo = Rx<UserInfo>(getIt<UserService>().userInfo()!);

  // final id = RxInt(0);
  // final permissionLevel = RxInt(0);
  // final star = RxInt(0);
  //
  // final name = RxString('userName');
  // final email = RxString('');
  // final permissionLevelExpireDate = RxString('');
  // final avatarLink = RxString('');
  late String time;
  late String dailyImageUrl;
  late String dailySentence;
  late String originateFrom;

  File? image;
  final picker = prefix.ImagePicker();
  bool _cropping = false;
   bool isSignIn=false;

  // final isBindQQ = RxBool(false);
  // final isCheckEmail = RxBool(false);
  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  void onInit() {
    getIt<UserBaseRepository>()
        .queryGetSign(userInfo.value.id)
        .then((value) {
       isSignIn = value;
       update(['updateSign']);
    });
    print('UserDataController onInit');
    time = DateTime.now().millisecondsSinceEpoch.toString();
    super.onInit();
  }

  @override
  void onClose() {
    print('UserDataController onClose');
    super.onClose();
  }

//选择图片
  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: prefix.ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      update(['getImage']);
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }

    ///返回图片文件
    final file =
        await cropImageDataWithNativeLibrary(state: editorKey.currentState!);
    late CancelFunc cancelLoading;
    cancelLoading = BotToast.showLoading();
    userRepository.queryPostAvatar(file!).then((value) {
      time = DateTime.now().millisecondsSinceEpoch.toString();
      cancelLoading();
      update(['updateImage']);
    });
    _cropping = false;
  }

  Future<File?> cropImageDataWithNativeLibrary(
      {required ExtendedImageEditorState state}) async {
    print('native library start cropping');

    final Rect? cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction!;

    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect!));
    }

    if (action.needFlip) {
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(RotateOption(rotateAngle));
    }
    option.outputFormat = OutputFormat.jpeg(88);
    final DateTime start = DateTime.now();
    final File result = await ImageEditor.editImageAndGetFile(
      image: img,
      imageEditorOption: option,
    );

    print('${DateTime.now().difference(start)} ：total time');
    return result;
  }

  //
  // void readDataFromPrefs() {
  //   UserInfo userInfo = userService.userInfo()!;
  //   id.value = userInfo.id;
  //   permissionLevel.value = userInfo.permissionLevel;
  //   star.value = userInfo.star;
  //
  //   name.value = userInfo.username;
  //   email.value = userInfo.email;
  //   permissionLevelExpireDate.value = userInfo.permissionLevelExpireDate;
  //   avatarLink.value = userInfo.avatar;
  //   // signature = prefs.getString('signature');
  //   // location = prefs.getString('location');
  //
  //   isBindQQ.value = userInfo.isBindQQ;
  //   isCheckEmail.value = userInfo.isCheckEmail;
  // }

  deleteUserInfo() {
    Get.find<GlobalController>().isLogin.value = false;
    picBox.put('auth', '');
    picBox.put('id', 0);
    picBox.put('permissionLevel', 0);
    picBox.put('star', 0);

    picBox.put('name', '');
    picBox.put('email', '');
    picBox.put('permissionLevelExpireDate', '');
    picBox.put('avatarLink', '');

    picBox.put('isBindQQ', false);
    picBox.put('isCheckEmail', false);
    Get.find<WaterFlowController>(tag: 'home').refreshIllustList();
  }

  Future<void> postDaily() async {
    await getIt<UserBaseRepository>()
        .queryPostSign(userInfo.value.id)
        .then((value) {
      originateFrom = value.sentence.originateFrom;
      dailySentence = value.sentence.content;
      dailyImageUrl = value.illustration.imageUrls[0].medium;
      isSignIn = true;
      update(['updateDaily']);
    });
  }
}
