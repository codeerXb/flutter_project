import 'package:get/get.dart';

class LoginController extends GetxController {
  var login = Login();
  var loading = false.obs;
  final Map sn = {}.obs;
  void setToken(value) {
    login.token.value = value;
  }

  void setLoading(value) {
    loading.value = value;
  }

  void setSn(key, password) {
    sn[key] = password;
    // sn.update(key, (val) => password);
    print('----------------------');
    print(sn.toString());
  }
}

class Login {
  var token = ''.obs;
}
