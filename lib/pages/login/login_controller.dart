import 'package:get/get.dart';

class LoginController extends GetxController {
  var login = Login();
  void setToken(value) {
    login.token.value = value;
  }
}

class Login {
  var token = ''.obs;
}
