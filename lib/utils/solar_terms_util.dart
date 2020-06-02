// ignore_for_file: constant_identifier_names
enum SolarTermsEnum {
  LICHUN, // --立春
  YUSHUI, // --雨水
  JINGZHE, // --惊蛰
  CHUNFEN, // 春分
  QINGMING, // 清明
  GUYU, // 谷雨
  LIXIA, // 立夏
  XIAOMAN, // 小满
  MANGZHONG, // 芒种
  XIAZHI, // 夏至
  XIAOSHU, // 小暑
  DASHU, // 大暑
  LIQIU, // 立秋
  CHUSHU, // 处暑
  BAILU, // 白露
  QIUFEN, // 秋分
  HANLU, // 寒露
  SHUANGJIANG, // 霜降
  LIDONG, // 立冬
  XIAOXUE, // 小雪
  DAXUE, // 大雪
  DONGZHI, // 冬至
  XIAOHAN, // 小寒
  DAHAN, // 大寒
}

/// 抄的网上的一个，原文：https://blog.csdn.net/Sun_LeiLei/article/details/50148297
class SolarTermsUtil {
  ///依次代表立春、雨水...大寒节气的C值
  var centuryArray = <SolarTermsEnum, double>{
    SolarTermsEnum.LICHUN: 3.87,
    SolarTermsEnum.YUSHUI: 18.73,
    SolarTermsEnum.JINGZHE: 5.63,
    SolarTermsEnum.CHUNFEN: 20.646,
    SolarTermsEnum.QINGMING: 4.81,
    SolarTermsEnum.GUYU: 20.1,
    SolarTermsEnum.LIXIA: 5.52,
    SolarTermsEnum.XIAOMAN: 21.04,
    SolarTermsEnum.MANGZHONG: 5.678,
    SolarTermsEnum.XIAZHI: 21.37,
    SolarTermsEnum.XIAOSHU: 7.108,
    SolarTermsEnum.DASHU: 22.83,
    SolarTermsEnum.LIQIU: 7.5,
    SolarTermsEnum.CHUSHU: 23.13,
    SolarTermsEnum.BAILU: 7.646,
    SolarTermsEnum.QIUFEN: 23.042,
    SolarTermsEnum.HANLU: 8.318,
    SolarTermsEnum.SHUANGJIANG: 23.438,
    SolarTermsEnum.LIDONG: 7.438,
    SolarTermsEnum.XIAOXUE: 22.36,
    SolarTermsEnum.DAXUE: 7.18,
    SolarTermsEnum.DONGZHI: 21.94,
    SolarTermsEnum.XIAOHAN: 5.4055,
    SolarTermsEnum.DAHAN: 20.12,
  };
  final double D = 0.2422;
  Map<SolarTermsEnum, List<int>> increaseOffsetMap = <SolarTermsEnum, List<int>>{}; // +1偏移
  Map<SolarTermsEnum, List<int>> decreaseOffsetmap = <SolarTermsEnum, List<int>>{}; // -1偏移
  int mYear;
  List<String> mSolarData = <String>[];
  List<String> mSolarName = <String>[];

  ///判断一天是什么节气
  ///@data2015-12-2下午2:49:32
  ///@param year
  ///@param data 月份占两位，日不确定，如一月一日为：011，五月十日为0510
  ///@return
  SolarTermsEnum getSolatName(int year, int month, int day) {
    if (year != mYear) {
      return _solarTermToString(year, month, day);
    }
    return null;
  }

  ///
  /// @param year
  ///            年份
  /// @param name
  ///            节气的名称
  /// @return 返回节气是相应月份的第几天
  int getSolarTermNum(int year, SolarTermsEnum solarTermName) {
    var centuryValue = 0.0; // 节气的世纪值，每个节气的每个世纪值都不同
    if (year < 2001 || year > 2100) {
      throw Exception(['不支持此年份：" + $year + "，目前只支持1901年到2100年的时间范围']);
    }
    centuryValue = centuryArray[solarTermName];
    var dateNum = 0;

    /// 计算 num =[Y///D+C]-L这是传说中的寿星通用公式
    /// 公式解读：年数的后2位乘0.2422加C(即：centuryValue)取整数后，减闰年数
    var y = year % 100; // 步骤1:取年分的后两位数
    if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
      // 闰年
      if (solarTermName == SolarTermsEnum.XIAOHAN ||
          solarTermName == SolarTermsEnum.DAHAN ||
          solarTermName == SolarTermsEnum.LICHUN ||
          solarTermName == SolarTermsEnum.YUSHUI) {
        // 注意：凡闰年3月1日前闰年数要减一，即：L=[(Y-1)/4],因为小寒、大寒、立春、雨水这两个节气都小于3月1日,所以
        // y = y-1
        y = y - 1; // 步骤2
      }
    }
    dateNum = (y * D + centuryValue).toInt() - y ~/ 4; // 步骤3，使用公式[Y///D+C]-L计算
    dateNum += specialYearOffset(year, solarTermName); // 步骤4，加上特殊的年分的节气偏移量
    return dateNum;
  }

  ///特例,特殊的年分的节气偏移量,由于公式并不完善，所以算出的个别节气的第几天数并不准确，在此返回其偏移量
  ///
  /// @param year
  ///            年份
  /// @param name
  ///            节气名称
  /// @return 返回其偏移量
  int specialYearOffset(int year, SolarTermsEnum name) {
    initOffsetMap();
    var offset = 0;
    offset += getOffset(decreaseOffsetmap, year, name, -1);
    offset += getOffset(increaseOffsetMap, year, name, 1);

    return offset;
  }

  int getOffset(Map<SolarTermsEnum, List<int>> map, int year, SolarTermsEnum name, int offset) {
    var off = 0;
    var years = map[name];
    if (null != years) {
      for (var i in years) {
        if (i == year) {
          off = offset;
          break;
        }
      }
    }
    return off;
  }

  SolarTermsEnum _solarTermToString(int year, int month, int day) {
    mYear = year;
    if (mSolarData != null) {
      mSolarData.clear();
    } else {
      mSolarData = <String>[];
    }
    if (mSolarName != null) {
      mSolarName.clear();
    } else {
      mSolarName = <String>[];
    }
    switch (month) {
      case 2:
        if (day >= getSolarTermNum(year, SolarTermsEnum.YUSHUI)) {
          return SolarTermsEnum.YUSHUI;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.LICHUN)) {
          return SolarTermsEnum.DAHAN;
        }
        return SolarTermsEnum.LICHUN;
      case 3:
        if (day >= getSolarTermNum(year, SolarTermsEnum.CHUNFEN)) {
          return SolarTermsEnum.CHUNFEN;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.JINGZHE)) {
          return SolarTermsEnum.YUSHUI;
        }
        return SolarTermsEnum.JINGZHE;
      case 4:
        if (day >= getSolarTermNum(year, SolarTermsEnum.GUYU)) {
          return SolarTermsEnum.GUYU;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.QINGMING)) {
          return SolarTermsEnum.CHUNFEN;
        }
        return SolarTermsEnum.QINGMING;
      case 5:
        if (day >= getSolarTermNum(year, SolarTermsEnum.XIAOMAN)) {
          return SolarTermsEnum.XIAOMAN;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.LIXIA)) {
          return SolarTermsEnum.GUYU;
        }
        return SolarTermsEnum.LIXIA;
      case 6:
        if (day >= getSolarTermNum(year, SolarTermsEnum.XIAZHI)) {
          return SolarTermsEnum.XIAZHI;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.MANGZHONG)) {
          return SolarTermsEnum.XIAOMAN;
        }
        return SolarTermsEnum.MANGZHONG;
      case 7:
        if (day >= getSolarTermNum(year, SolarTermsEnum.DASHU)) {
          return SolarTermsEnum.DASHU;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.XIAOSHU)) {
          return SolarTermsEnum.XIAZHI;
        }
        return SolarTermsEnum.XIAOSHU;
      case 8:
        if (day >= getSolarTermNum(year, SolarTermsEnum.CHUSHU)) {
          return SolarTermsEnum.CHUSHU;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.LIQIU)) {
          return SolarTermsEnum.DASHU;
        }
        return SolarTermsEnum.LIQIU;
      case 9:
        if (day >= getSolarTermNum(year, SolarTermsEnum.QIUFEN)) {
          return SolarTermsEnum.QIUFEN;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.BAILU)) {
          return SolarTermsEnum.CHUSHU;
        }
        return SolarTermsEnum.BAILU;
      case 10:
        if (day >= getSolarTermNum(year, SolarTermsEnum.SHUANGJIANG)) {
          return SolarTermsEnum.SHUANGJIANG;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.HANLU)) {
          return SolarTermsEnum.QIUFEN;
        }
        return SolarTermsEnum.HANLU;
      case 11:
        if (day >= getSolarTermNum(year, SolarTermsEnum.XIAOXUE)) {
          return SolarTermsEnum.XIAOXUE;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.LIDONG)) {
          return SolarTermsEnum.SHUANGJIANG;
        }
        return SolarTermsEnum.LIDONG;
      case 12:
        if (day >= getSolarTermNum(year, SolarTermsEnum.DONGZHI)) {
          return SolarTermsEnum.DONGZHI;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.DAXUE)) {
          return SolarTermsEnum.XIAOXUE;
        }
        return SolarTermsEnum.DAXUE;
      case 1:
        if (day >= getSolarTermNum(year, SolarTermsEnum.DAHAN)) {
          return SolarTermsEnum.DAHAN;
        } else if (day < getSolarTermNum(year, SolarTermsEnum.XIAOHAN)) {
          return SolarTermsEnum.DONGZHI;
        }
        return SolarTermsEnum.XIAOHAN;
      default:
        return SolarTermsEnum.XIAZHI;
    }
    // 1
//    mSolarName.add('立春');
//    mSolarData.add('02${getSolarTermNum(year, SolarTermsEnum.LICHUN)}');
//    // 2
//    mSolarName.add('雨水');
//    mSolarData.add('02${getSolarTermNum(year, SolarTermsEnum.YUSHUI)}');
//    // 3
//    mSolarName.add('惊蛰');
//    mSolarData.add('03${getSolarTermNum(year, SolarTermsEnum.JINGZHE)}');
//    // 4
//    mSolarName.add('春分');
//    mSolarData.add('03${getSolarTermNum(year, SolarTermsEnum.CHUNFEN)}');
//    // 5
//    mSolarName.add('清明');
//    mSolarData.add('04${getSolarTermNum(year, SolarTermsEnum.QINGMING)}');
//    // 6
//    mSolarName.add('谷雨');
//    mSolarData.add('04${getSolarTermNum(year, SolarTermsEnum.GUYU)}');
//    // 7
//    mSolarName.add('立夏');
//    mSolarData.add('05${getSolarTermNum(year, SolarTermsEnum.LIXIA)}');
//    // 8
//    mSolarName.add('小满');
//    mSolarData.add('05${getSolarTermNum(year, SolarTermsEnum.XIAOMAN)}');
//    // 9
//    mSolarName.add('芒种');
//    mSolarData.add('06${getSolarTermNum(year, SolarTermsEnum.MANGZHONG)}');
//    // 10
//    mSolarName.add('夏至');
//    mSolarData.add('06${getSolarTermNum(year, SolarTermsEnum.XIAZHI)}');
//    // 11
//    mSolarName.add('小暑');
//    mSolarData.add('07${getSolarTermNum(year, SolarTermsEnum.XIAOSHU)}');
//    // 12
//    mSolarName.add('大暑');
//    mSolarData.add('07${getSolarTermNum(year, SolarTermsEnum.DASHU)}');
//    // 13
//    mSolarName.add('立秋');
//    mSolarData.add('08${getSolarTermNum(year, SolarTermsEnum.LIQIU)}');
//    // 14
//    mSolarName.add('处暑');
//    mSolarData.add('08${getSolarTermNum(year, SolarTermsEnum.CHUSHU)}');
//    // 15
//    mSolarName.add('白露');
//    mSolarData.add('09${getSolarTermNum(year, SolarTermsEnum.BAILU)}');
//    // 16
//    mSolarName.add('秋分');
//    mSolarData.add('09${getSolarTermNum(year, SolarTermsEnum.QIUFEN)}');
//    // 17
//    mSolarName.add('寒露');
//    mSolarData.add('10${getSolarTermNum(year, SolarTermsEnum.HANLU)}');
//    // 18
//    mSolarName.add('霜降');
//    mSolarData.add('10${getSolarTermNum(year, SolarTermsEnum.SHUANGJIANG)}');
//    // 19
//    mSolarName.add('立冬');
//    mSolarData.add('11${getSolarTermNum(year, SolarTermsEnum.LIDONG)}');
//    // 20
//    mSolarName.add('小雪');
//    mSolarData.add('11${getSolarTermNum(year, SolarTermsEnum.XIAOXUE)}');
//    // 21
//    mSolarName.add('大雪');
//    mSolarData.add('12${getSolarTermNum(year, SolarTermsEnum.DAXUE)}');
//    // 22
//    mSolarName.add('冬至');
//    mSolarData.add('12${getSolarTermNum(year, SolarTermsEnum.DONGZHI)}');
//    // 23
//    mSolarName.add('小寒');
//    mSolarData.add('01${getSolarTermNum(year, SolarTermsEnum.XIAOHAN)}');
//    // 24
//    mSolarName.add('大寒');
//    mSolarData.add('01${getSolarTermNum(year, SolarTermsEnum.DAHAN)}');
  }

  void initOffsetMap() {
    decreaseOffsetmap[SolarTermsEnum.YUSHUI] = <int>[2026]; // 雨水
    increaseOffsetMap[SolarTermsEnum.CHUNFEN] = <int>[2084]; // 春分
    increaseOffsetMap[SolarTermsEnum.XIAOMAN] = <int>[2008]; // 小满
    increaseOffsetMap[SolarTermsEnum.MANGZHONG] = <int>[1902]; // 芒种
    increaseOffsetMap[SolarTermsEnum.XIAZHI] = <int>[1928]; // 夏至
    increaseOffsetMap[SolarTermsEnum.XIAOSHU] = <int>[1925, 2016]; // 小暑
    increaseOffsetMap[SolarTermsEnum.DASHU] = <int>[1922]; // 大暑
    increaseOffsetMap[SolarTermsEnum.LIQIU] = <int>[2002]; // 立秋
    increaseOffsetMap[SolarTermsEnum.BAILU] = <int>[1927]; // 白露
    increaseOffsetMap[SolarTermsEnum.QIUFEN] = <int>[1942]; // 秋分
    increaseOffsetMap[SolarTermsEnum.SHUANGJIANG] = <int>[2089]; // 霜降
    increaseOffsetMap[SolarTermsEnum.LIDONG] = <int>[2089]; // 立冬
    increaseOffsetMap[SolarTermsEnum.XIAOXUE] = <int>[1978]; // 小雪
    increaseOffsetMap[SolarTermsEnum.DAXUE] = <int>[1954]; // 大雪
    decreaseOffsetmap[SolarTermsEnum.DONGZHI] = <int>[1918, 2021]; // 冬至
    increaseOffsetMap[SolarTermsEnum.XIAOHAN] = <int>[1982]; // 小寒
    decreaseOffsetmap[SolarTermsEnum.XIAOHAN] = <int>[2019]; // 小寒
    increaseOffsetMap[SolarTermsEnum.DAHAN] = <int>[2082]; // 大寒
  }
}
