import 'dart:io';
import 'dart:typed_data';
import 'package:image_editor/image_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:image_picker/image_picker.dart' as prefix;
import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sharemoe/controller/search_controller.dart';
import 'package:sharemoe/data/repository/illust_repository.dart';
import 'package:sharemoe/data/repository/user_repository.dart';
import 'package:file_picker/file_picker.dart';

class UserController extends GetxController {
  final id = RxInt(0);
  final permissionLevel = RxInt(0);
  final star = RxInt(0);

  final name = RxString('userName');
  final email = RxString('');
  final permissionLevelExpireDate = RxString('');
  final avatarLink = RxString('');

  File? image;
  final picker = prefix.ImagePicker();
  bool _cropping = false;

  final isBindQQ = RxBool(false);
  final isCheckEmail = RxBool(false);
  final PicBox _picBox = PicBox();
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  void onInit() {
    print('UserDataController onInit');
    readDataFromPrefs();
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
  //TODO 调不通
    ///返回图片文件
  final file =await cropImageDataWithNativeLibrary(
      state: editorKey.currentState!);
    getIt<UserRepository>().queryPostAvatar(file!);
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

    final DateTime start = DateTime.now();
    final File result = await ImageEditor.editImageAndGetFile(
      image: img,
      imageEditorOption: option,
    );

    print('${DateTime.now().difference(start)} ：total time');
    return result;
  }

  void readDataFromPrefs() {
    id.value = _picBox.id;
    permissionLevel.value = _picBox.permissionLevel;
    star.value = _picBox.star;

    name.value = _picBox.name;
    email.value = _picBox.email;
    permissionLevelExpireDate.value = _picBox.permissionLevelExpireDate;
    avatarLink.value = _picBox.avatarLink;
    // signature = prefs.getString('signature');
    // location = prefs.getString('location');

    isBindQQ.value = _picBox.isBindQQ;
    isCheckEmail.value = _picBox.isCheckEmail;
  }

  deleteUserInfo() {
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
  }

// submitCode(String code) async {
//   CancelFunc cancelLoading;
//   try {
//     cancelLoading = BotToast.showLoading();
//     String url = '/users/${picBox.get('id')}/permissionLevel';
//     Map<String, dynamic> queryParameters = {'exchangeCode': code};
//     Response response =
//     await dioPixivic.put(url, queryParameters: queryParameters);
//     cancelLoading();
//     BotToast.showSimpleNotification(title: response.data['message']);
//     setPrefs(response.data['data']);
//     readDataFromPrefs();
//     getVipUrl();
//   } catch (e) {
//     cancelLoading();
//   }
// }
}

class ImageSaver {
  static Future<String?> save(String name, Uint8List fileData) async {
    final AssetEntity? imageEntity =
        await PhotoManager.editor.saveImage(fileData);
    final File? file = await imageEntity?.file;
    return file?.path;
  }
}
