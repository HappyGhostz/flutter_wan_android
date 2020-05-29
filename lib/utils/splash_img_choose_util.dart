import 'package:flutterwanandroid/utils/solar_terms_util.dart';

var splashImgs = <SolarTermsEnum, String>{
  SolarTermsEnum.LICHUN: 'assets/lichun.jpeg',
  SolarTermsEnum.YUSHUI: 'assets/yushui.jpg',
  SolarTermsEnum.JINGZHE: 'assets/jingzhe.jpeg',
  SolarTermsEnum.CHUNFEN: 'assets/chunfen.png',
  SolarTermsEnum.QINGMING: 'assets/qingming.jpg',
  SolarTermsEnum.GUYU: 'assets/guyu.jpeg',
  SolarTermsEnum.LIXIA: 'assets/lixia.jpeg',
  SolarTermsEnum.XIAOMAN: 'assets/xiaoman.jpg',
  SolarTermsEnum.MANGZHONG: 'assets/mangzhong.jpg',
  SolarTermsEnum.XIAZHI: 'assets/xiazhi.jpg',
  SolarTermsEnum.XIAOSHU: 'assets/xiaoshu.jpg',
  SolarTermsEnum.DASHU: 'assets/dashu.jpg',
  SolarTermsEnum.LIQIU: 'assets/liqiu.jpg',
  SolarTermsEnum.CHUSHU: 'assets/chushu.jpg',
  SolarTermsEnum.BAILU: 'assets/bailu.jpeg',
  SolarTermsEnum.QIUFEN: 'assets/qiufen.jpeg',
  SolarTermsEnum.HANLU: 'assets/hanlu.jpg',
  SolarTermsEnum.SHUANGJIANG: 'assets/shuangjiang.jpg',
  SolarTermsEnum.LIDONG: 'assets/lidong.jpeg',
  SolarTermsEnum.XIAOXUE: 'assets/xiaoxue.jpg',
  SolarTermsEnum.DAXUE: 'assets/daxue.gif',
  SolarTermsEnum.DONGZHI: 'assets/dongzhi.jpeg',
  SolarTermsEnum.XIAOHAN: 'assets/xiaohan.jpg',
  SolarTermsEnum.DAHAN: 'assets/dahan.jpeg',
};

var famousSentences = <SolarTermsEnum, List<String>>{
  SolarTermsEnum.LICHUN: ['今朝一岁大家添', '不是人间偏我老'],
  SolarTermsEnum.YUSHUI: ['最是一年春好处', '绝胜烟柳满皇都'],
  SolarTermsEnum.JINGZHE: ['闻道新年入山里', '蛰虫惊动春风起'],
  SolarTermsEnum.CHUNFEN: ['等闲识得东风面', '万紫千红总是春'],
  SolarTermsEnum.QINGMING: ['清明时节雨纷纷', '路上行人欲断魂'],
  SolarTermsEnum.GUYU: ['牡丹破萼樱桃熟', '未许飞花减却春'],
  SolarTermsEnum.LIXIA: ['谢却海棠飞尽絮', '困人天气日初长'],
  SolarTermsEnum.XIAOMAN: ['一春多雨慧当悭', '今岁还防似去年'],
  SolarTermsEnum.MANGZHONG: ['乙酉甲申雷雨惊', '乘除却贺芒种晴'],
  SolarTermsEnum.XIAZHI: ['漠漠水田飞白鹭', '阴阴夏木啭黄鹂'],
  SolarTermsEnum.XIAOSHU: ['幸有心期当小暑', '葛衣纱帽望回车'],
  SolarTermsEnum.DASHU: ['竹风荷雨来消暑', '玉李冰瓜可疗饥'],
  SolarTermsEnum.LIQIU: ['苦热恨无行脚处', '微凉喜到立秋时'],
  SolarTermsEnum.CHUSHU: ['寂寞柴门人不到', '空林独与白云期'],
  SolarTermsEnum.BAILU: ['白云映水摇空城', '白露垂珠滴秋月'],
  SolarTermsEnum.QIUFEN: ['试上高楼清入骨', '岂如春色嗾人狂'],
  SolarTermsEnum.HANLU: ['关塞极天唯鸟道', '江湖满地一渔翁'],
  SolarTermsEnum.SHUANGJIANG: ['独出前门望野田', '月明荞麦花如雪'],
  SolarTermsEnum.LIDONG: ['砌下梨花一堆雪', '明年谁此凭阑干'],
  SolarTermsEnum.XIAOXUE: ['愁人正在书窗下', '一片飞来一片寒'],
  SolarTermsEnum.DAXUE: ['幽州思妇十二月', '停歌罢笑双蛾摧'],
  SolarTermsEnum.DONGZHI: ['邯郸驿里逢冬至', '抱膝灯前影伴身'],
  SolarTermsEnum.XIAOHAN: ['满庭木叶愁风起', '透幌纱窗惜月沉'],
  SolarTermsEnum.DAHAN: ['寻常一样窗前月', '才有梅花便不同'],
};

String getSplashImg(SolarTermsEnum solarTermsEnum) {
  return splashImgs[solarTermsEnum];
}

List<String> getFamousSentence(SolarTermsEnum solarTermsEnum) {
  return famousSentences[solarTermsEnum];
}
