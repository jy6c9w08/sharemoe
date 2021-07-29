import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/data/model/message.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class MessageController extends GetxController {
  final Rx<List> messageList = Rx<List>([]);

  Future<List<Message>> getData() async {
    return await getIt<UserRepository>()
        .queryMessageList(255750, 1,( DateTime.now().millisecondsSinceEpoch)~/1000);
  }

  @override
  void onInit() {
    getData().then((value) => messageList.value = value);
    super.onInit();
  }
}
