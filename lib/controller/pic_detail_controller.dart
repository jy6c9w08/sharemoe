import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/config/hive_config.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class PicDetailController extends GetxController {
 final  int illustId;

  PicDetailController({required this.illustId});

  uploadHistory() async{
    Map<String, String> body = {
      'userId': picBox.get('id').toString(),
      'illustId': illustId.toString()
    };
   await getIt<UserRepository>().queryNewUserViewIllustHistory(picBox.get('id'), body);
  }
  @override
  void onInit() {
    uploadHistory();
    super.onInit();
  }
}