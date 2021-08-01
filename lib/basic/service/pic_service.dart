// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../config/get_it_config.dart';

///暂时无用
void initServices() async {
  // await Get.putAsync(() => HiveService().init());
  await Get.putAsync(()=>GitService().init());

}


// class HiveService extends GetxService {
//   Future<HiveService> init() async {
//    HiveConfig.initHive();
//    return this;
//   }
//
//
// }

class GitService extends GetxService{
  Future<GitService> init() async {
    configureDependencies();
    return this;
  }
}
