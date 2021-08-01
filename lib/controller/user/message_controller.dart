// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/controller/user/type_controller.dart';
import 'package:sharemoe/controller/user/user_controller.dart';
import 'package:sharemoe/data/model/message.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class MessageController extends GetxController {
  final Rx<List> messageList = Rx<List>([]);
  final String model;

  MessageController({required this.model});

  Future<List<Message>> getCommentData() async {
    return await getIt<UserRepository>().queryMessageList(
        getIt<UserService>().userInfo()!.id,
        1,
        (DateTime.now().millisecondsSinceEpoch) ~/ 1000);
  }

  Future<List<Message>> getThumbData() async {
    Get.find<TypeController>().getTotalUnReade();
    Get.find<UserController>().getUnReadeMessageNumber();
    return await getIt<UserRepository>().queryMessageList(
        getIt<UserService>().userInfo()!.id,
        2,
        (DateTime.now().millisecondsSinceEpoch) ~/ 1000);
  }

  @override
  void onInit() {
    model == 'comment'
        ? getCommentData().then((value) => messageList.value = value)
        : getThumbData().then((value) => messageList.value = value);
    super.onInit();
  }

  @override
  void onClose() {
    Get.find<TypeController>().getTotalUnReade();
    Get.find<UserController>().getUnReadeMessageNumber();
    super.onClose();
  }
}
