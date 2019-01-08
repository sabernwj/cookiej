import './utils/accessController.dart';
import './utils/httpController.dart';
import './utils/localstorageHelper.dart';

class Boot{
  ///初始化静态类中的一些成员
  static init() {
      HttpController.init();
  }
}