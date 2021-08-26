// Dart imports:
import 'dart:io';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart' as prefix;
import 'package:sharemoe/basic/constant/pic_texts.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/basic/util/pic_url_util.dart';
import 'package:sharemoe/controller/water_flow_controller.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';
import 'package:sharemoe/data/repository/vip_repository.dart';
import '../global_controller.dart';

class UserController extends GetxController {
  late UserInfo userInfo = getIt<UserService>().userInfo()!;
  late String time;
  late String dailyImageUrl;
  late String dailySentence;
  late String originateFrom;

  File? image;
  final picker = prefix.ImagePicker();
  bool _cropping = false;
  bool isSignIn = false;
  int unReadMessageCount = 0;

  static final UserService userService = getIt<UserService>();
  static final UserRepository userRepository = getIt<UserRepository>();
  final TextEditingController codeInputTextEditingController =
      TextEditingController();
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  void onInit() {
    getIt<UserBaseRepository>().queryGetSign(userInfo.id).then((value) {
      isSignIn = value;
      update(['updateSign']);
    });
    print('UserDataController onInit');
    time = DateTime.now().millisecondsSinceEpoch.toString();
    getUnReadeMessageNumber();
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
        await picker.pickImage(source: prefix.ImageSource.gallery);

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

  logout() {
    userService.signOutByUser();
    Get.find<GlobalController>().isLogin.value = false;

    Get.find<WaterFlowController>(tag: 'home').refreshIllustList();
  }

  Future getUnReadeMessageNumber() async {
    await userRepository.queryUnReadMessage(userInfo.id).then((value) {
      unReadMessageCount = value;
      update(['UnReadeMessageNumber']);
    });
  }

  Future<void> postDaily() async {
    await getIt<UserBaseRepository>().queryPostSign(userInfo.id).then((value) {
      originateFrom = value.sentence.originateFrom;
      dailySentence = value.sentence.content;
      dailyImageUrl = value.illustration.imageUrls[0].medium;
      isSignIn = true;
      update(['updateSign']);
    });
  }

  updateUserInfo(UserInfo userInfo){
    this.userInfo=userInfo;
    update(['updateUserInfo']);
  }

  jumpToVIPTB()async{
    if (await canLaunch(PicExternalLinkLink.JSTB)) {
    await launch(PicExternalLinkLink.JSTB);
    } else {
    throw 'Could not launch ${PicExternalLinkLink.JSTB}';
    }
  }
  jumpToVIPWD()async{
    if (await canLaunch(PicExternalLinkLink.WD)) {
    await launch(PicExternalLinkLink.WD);
    } else {
    throw 'Could not launch ${PicExternalLinkLink.WD}';
    }
  }

  getVIP() async {
    await getIt<VIPRepository>().queryGetVIP(
        userService.userInfo()!.id, codeInputTextEditingController.text);
    UserInfo _userInfo = await getIt<UserBaseRepository>()
        .queryUserInfo(userService.userInfo()!.id);
    this.userInfo=_userInfo;
    userService.updateUserInfo(_userInfo);
    await getIt<PicUrlUtil>().getVIPAddress();
    update(['updateVIP']);
    codeInputTextEditingController.text='';
  }
}
