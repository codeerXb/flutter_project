import 'package:get/get.dart';

class ToolbarController extends GetxController {
  var pageIndex = 0.obs;

//底部下标
  void setPageIndex(int value) {
    pageIndex.value = value;
  }
}
