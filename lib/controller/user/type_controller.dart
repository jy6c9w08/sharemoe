import 'package:get/get.dart';
import 'package:sharemoe/basic/config/get_it_config.dart';
import 'package:sharemoe/basic/service/user_service.dart';
import 'package:sharemoe/data/repository/user_repository.dart';

class TypeController extends GetxController {
  List<int> unReadNumberList = List.generate(4, (index) => 0);

  Future getTotalUnReade()async{
   await getIt<UserRepository>()
        .queryUnReadMessageByType(getIt<UserService>().userInfo()!.id)
        .then((value) {
      for(int i=0;i<value.length;i++){
        unReadNumberList[i]=value[i]['unread'];
      }
      update(['TotalUnReade']);
    });
  }

  @override
  void onInit() {
    getTotalUnReade();
    super.onInit();
  }
}
