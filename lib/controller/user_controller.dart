import 'package:get/get.dart' hide Response;
import 'package:sharemoe/basic/config/hive_config.dart';



class UserController extends GetxController {
  final id = RxInt(0);
  final permissionLevel = RxInt(0);
  final star = RxInt(0);

  final name = RxString('userName');
  final email = RxString('');
  final permissionLevelExpireDate = RxString('');
  final avatarLink = RxString('');
  // String signature;
  // String location;

  final isBindQQ = RxBool(false);
  final isCheckEmail = RxBool(false);

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

  void readDataFromPrefs() {
    id.value = picBox.get('id');
    permissionLevel.value = picBox.get('permissionLevel');
    star.value = picBox.get('star');

    name.value = picBox.get('name');
    email.value = picBox.get('email');
    permissionLevelExpireDate.value =
        picBox.get('permissionLevelExpireDate');
    avatarLink.value = picBox.get('avatarLink');
    // signature = prefs.getString('signature');
    // location = prefs.getString('location');

    isBindQQ.value = picBox.get('isBindQQ');
    isCheckEmail.value = picBox.get('isCheckEmail');
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
