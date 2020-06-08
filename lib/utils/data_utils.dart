class DataUtil {
  static bool isToDay(String dataValue) {
    if (dataValue.contains('刚') || dataValue.contains('时')) {
      return true;
    } else if (dataValue.contains('天')) {
      return false;
    }
    try {
      var today = DateTime.now();
      var time = DateTime.parse(dataValue);
      var standardDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
      var diff = standardDate.difference(time);
      if (diff < Duration(days: 1)) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
