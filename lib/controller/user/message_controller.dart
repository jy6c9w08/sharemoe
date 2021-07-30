import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/comment.dart';
import 'package:sharemoe/data/model/message.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class MessageController extends GetxController {
  final Rx<List> messageList = Rx<List>([]);
  final String model;

  MessageController({required this.model});

  Future<List<Message>> getCommentData() async {
    return await getIt<UserRepository>().queryMessageList(
        255750, 1, (DateTime.now().millisecondsSinceEpoch) ~/ 1000);
  }

  Future<List<Message>> getThumbData() async {
    return await getIt<UserRepository>().queryMessageList(
        255750, 2, (DateTime.now().millisecondsSinceEpoch) ~/ 1000);
  }

  @override
  void onInit() {
    model == 'comment'
        ? getCommentData().then((value) => messageList.value = value)
        : getThumbData().then((value) => messageList.value = value);
    super.onInit();
  }
}
