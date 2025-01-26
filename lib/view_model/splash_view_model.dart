import 'package:get/get.dart';
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/view/login/welcome_view.dart';
import 'package:online_groceries/view/main_tabview/main_tabview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_payload_model.dart';

class SplashViewModel extends GetxController {
  final userPayload = UserPayloadModel().obs;

  void loadView() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    if (isAuthenticated) {
      Get.offAll(() => const MainTabView());
    } else {
      Get.offAll(() => const WelcomeView());
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    Get.to(() => const WelcomeView());
  }


  void goAfterLoginMainTab(){
    userPayload.value = UserPayloadModel.fromJson( Globs.udValue(Globs.userPayload));
    Get.to(() => const MainTabView() );
  }

  void setData() {
    userPayload.value =
        UserPayloadModel.fromJson(Globs.udValue(Globs.userPayload));

  }


}
