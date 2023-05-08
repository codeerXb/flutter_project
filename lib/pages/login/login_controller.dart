import 'package:get/get.dart';

class LoginController extends GetxController {
  var login = Login();
  var loading = false.obs;
  final Map sn = {}.obs;
  final Map equipment = {}.obs;
  final Map userEquipment = {}.obs;
  String state = '';

  var isSn = ''.obs;
  void setToken(value) {
    login.token.value = value;
  }

  void setState(value) {
    login.state = value;
  }

  void setUserToken(value) {
    login.userToken.value = value;
  }

  void setEquipment(key, value) {
    equipment[key] = value;
  }

  void setUserEquipment(key, value) {
    userEquipment[key] = value;
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
  }
}

class Login {
  var token = ''.obs;
  var session = ''.obs;
  var userToken = ''.obs;
  // 云端 cloud   本地 local
  var state = 'cloud';
}
