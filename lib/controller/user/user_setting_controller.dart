import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/provider/api/user_base/user_base_rest_client.dart';
import 'package:sharemoe/data/repository/user_base_repository.dart';

class UserSettingController extends GetxController {
  late UserInfo userInfo = getIt<UserService>().userInfo()!;

  init() async {
    userInfo = await getIt<UserBaseRepository>()
        .queryUserInfo(getIt<UserService>().userInfo()!.id);
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    init();
    super.onInit();
  }
}
