// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:sharemoe/data/model/daily.dart';
import 'package:sharemoe/data/model/result.dart';
import 'package:sharemoe/data/model/user_info.dart';
import 'package:sharemoe/data/model/verification.dart';
import 'package:sharemoe/data/provider/api/user_base/user_base_rest_client.dart';

@lazySingleton
class UserBaseRepository {
  final UserBaseRestClient _userBaseRestClient;

  UserBaseRepository(this._userBaseRestClient);

  processDioError(obj) {
    final res = (obj as DioError).response;
    BotToast.showSimpleNotification(title: res!.statusMessage!);
  }

  Future<UserInfo> queryUserLogin(
      String vid, String code, Map<String, dynamic> body) {
    return _userBaseRestClient
        .queryUserLoginInfo(vid, code, body)
        .then((value) => value.data);
  }

  Future queryUserRegisters(
      String vid, String code, Map<String, dynamic> body) {
    return _userBaseRestClient
        .queryUserRegistersInfo(vid, code, body)
        .then((value) => value.data);
    //     .catchError((Object obj) {
    //   switch (obj.runtimeType) {
    //     case DioError:
    //       final res = (obj as DioError).response;
    //       if (res.statusCode == 200) {
    //         // 切换至login界面，并给出提示
    //         // BotToast.showSimpleNotification(
    //         //     title: TextZhLoginPage().registerSucceed);
    //       } else {
    //         // isLogin = false;
    //         print(res.data['message']);
    //         BotToast.showSimpleNotification(title: res.data['message']);
    //       }
    //       break;
    //     default:
    //   }
    // });
  }

  Future<Verification> queryVerificationCode() {
    return _userBaseRestClient
        .queryVerificationCodeInfo()
        .then((value) => value.data)
        .catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          // BotToast.showSimpleNotification(
          //     title: TextZhLoginPage().errorGetVerificationCode);
          break;
        default:
      }
    });
  }

  Future queryMessageVerificationCode(String vid, String code, int phone) {
    return _userBaseRestClient
        .queryMessageVerificationCodeInfo(vid, code, phone)
        .then((value) => value.data);
  }

  Future<Result> queryResetPasswordByEmail(String emailAddr) {
    return _userBaseRestClient
        .queryResetPasswordByEmailInfo(emailAddr)
        .then((value) => value.data);
  }

  Future<bool> queryVerifyUserNameIsAvailable(String userName) {
    return _userBaseRestClient
        .queryVerifyUserNameIsAvailableInfo(userName)
        .then((value) {
      return true;
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if (res!.statusCode == 409) {
            return false;
          } else {
            return true;
          }
        default:
          return true;
      }
    });
  }


  Future<bool> queryVerifyEmailIsAvailable(String emailAddress) {
    return _userBaseRestClient
        .queryVerifyEmailIsAvailableInfo(emailAddress)
        .then((value) {
      return true;
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if (res!.statusCode == 409) {
            return false;
          } else {
            return true;
          }
        default:
          return true;
      }
    });
  }
  Future<bool> queryIsUserVerifyPhone(String  phone) {
    return _userBaseRestClient
        .queryIsUserVerifyPhoneInfo(phone)
        .then((value) {
      return true;
    }).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          if (res!.statusCode == 409) {
            return false;
          } else {
            return true;
          }
        default:
          return true;
      }
    });
  }

  Future<UserInfo> queryUserInfo(int userId) {
    return _userBaseRestClient
        .querySearchUserInfo(userId)
        .then((value) => value.data);
  }

  Future<DailyModel> queryPostSign(int userId) {
    return _userBaseRestClient.queryPostSignInfo().then((value) => value.data);
  }

  Future<bool> queryGetSign(int userId) {
    return _userBaseRestClient.queryGetSignInfo().then((value) => value.data);
  }
}
