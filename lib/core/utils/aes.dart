import 'package:encrypt/encrypt.dart';

class AESUtil {
  static String generateAES(String value) {
    final key = Key.fromUtf8('9007199254740992');
    final iv = IV.fromUtf8('9007199254740992');
  
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }
}
