import 'package:get/get.dart';

class ToolbarController extends GetxController {
  var pageIndex = 0.obs;
  var currentNoiselevel = (-40).obs;

//底部下标
  void setPageIndex(int value) {
    pageIndex.value = value;
  }

  //当前噪声等级
  void setCurrentNoiselevel(value) {
    currentNoiselevel.value = value;
  }
}
