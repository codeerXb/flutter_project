import 'package:get/get.dart';

class LoginController extends GetxController {
  var login = Login();
  var loading = false.obs;
  final Map sn = {}.obs;
  final Map equipment = {}.obs;
  var isSn = ''.obs;
  void setToken(value) {
    login.token.value = value;
  }

  void setUserToken(value) {
    login.userToken.value = value;
  }

  void setEquipment(key, value) {
    equipment[key] = value;
  }

  void setSession(value) {
    login.session.value = value;
  }

  void setLoading(value) {
    loading.value = value;
  }

  void setSn(key, password) {
    sn[key] = password;
    isSn.value = key;
    // sn.update(key, (val) => password);
    print('----------------------');
    print(sn.toString());
  }
}

class Login {
  var token = ''.obs;
  var session = ''.obs;
  var userToken = ''.obs;
}
