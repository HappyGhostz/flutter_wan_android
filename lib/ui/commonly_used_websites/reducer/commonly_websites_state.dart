import 'package:flutterwanandroid/module/commonly_websites_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class CommonlyUsedWebSitesState extends Cloneable<CommonlyUsedWebSitesState> {
  DataLoadStatus dataLoadStatus;
  List<CommonlyUsedWebSitesData> commonlyUsedWebSitesDatas;

  @override
  CommonlyUsedWebSitesState clone() {
    return CommonlyUsedWebSitesState()
      ..dataLoadStatus = dataLoadStatus
      ..commonlyUsedWebSitesDatas = commonlyUsedWebSitesDatas;
  }
}
