
import 'package:get/get.dart';

class goto{
  static Transition transition = Transition.rightToLeftWithFade;
  static Duration duration = const Duration(milliseconds: 500);

  static home_screen(){
    Get.to(home_screen());
  }

  static ProviderHome(){
    Get.to(ProviderHome());
  }

  static UserOrProvider(){
    Get.to(UserOrProvider());
  }
}