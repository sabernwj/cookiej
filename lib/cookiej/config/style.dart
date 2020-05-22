import 'package:cookiej/cookiej/action/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class CookieJColors{
  

  static final Map<String,MaterialColor> themeColors= {
    //'默认白':CookieJColors.customWhite,
    '薄荷绿':Colors.teal,
    '经典黑':CookieJColors.customBlack,
    '谷歌蓝':Colors.blue,
    '琥珀黄':Colors.amber,
    '钢蓝灰':Colors.blueGrey,
    '胡萝卜':Colors.orange,
    '天空蓝':Colors.cyan,
    '中国红':Colors.red,
    '鲑鱼粉':CookieJColors.salmonPink,
    '杏黄色':CookieJColors.apricot,
    '少女粉':CookieJColors.girlPink,
  };
  static const int customWhiteValue=0xFFFFFFFF;
  static const int customBlackValue = 0xFF363636;
  static const int salmonPinkValue=0xFFFA8072;
  static const int apricotValue=0xFFF8B878;
  static const int girlPinkValue=0xFFFA7298;

  static final MaterialColor apricot=getMaterialColor(apricotValue);
  static final MaterialColor salmonPink=getMaterialColor(salmonPinkValue);
  static final MaterialColor customBlack =getMaterialColor(customBlackValue);
  static final MaterialColor girlPink=getMaterialColor(girlPinkValue);
  static final MaterialColor customWhite=getMaterialColor(customWhiteValue);

  static const Color primaryValue = Color(0xFF24292E);
  static const Color primaryLightValue = Color(0xFF42464b);
  static const Color primaryDarkValue = Color(0xFF121917);

  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color miWhite = Color(0xffececec);
  static const Color white = Color(0xFFFFFFFF);
  static const Color actionBlue = Color(0xff267aff);
  static const Color subTextColor = Color(0xbbffffff);
  static const Color subLightTextColor = Color(0xffc4c4c4);

  static const Color mainBackgroundColor = miWhite;

  static const Color mainTextColor = primaryDarkValue;
  static const Color textColorWhite = white;

  static void pushTheme(Store store, String name) {
    ThemeData themeData;
    themeData = getThemeData(name);
    store.dispatch(RefreshThemeState(ThemeState(name,themeData)));
  }

  static ThemeData getThemeData(String themeName,{bool isDarkMode=false}) {
    MaterialColor color=themeColors[themeName];
    //颜色的亮度，涉及夜间模式下深色主题的活动颜色设置
    double luminance=color.computeLuminance();
    color=luminance<0.15&&isDarkMode?Colors.teal:color;
    var theme= ThemeData(
      fontFamily: null,
      primarySwatch: color,
      brightness: isDarkMode?Brightness.dark:Brightness.light,
      //主颜色属于暗色还是亮色，关乎到文本的黑或白
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      //选中文本时的背景颜色,
      textSelectionHandleColor:color.shade300,
      //画布颜色(背景色)
      canvasColor: isDarkMode?Colors.grey[900]:Colors.grey[100],
      //前景色
      accentColor: color.shade600,
      //用于突出显示切换Widget（如Switch，Radio和Checkbox）的活动状态的颜色。
      dialogBackgroundColor: isDarkMode?Colors.grey[850]:Colors.white,
      toggleableActiveColor:color.shade500,
      unselectedWidgetColor: isDarkMode ? customBlack : customWhite,
      //cardColor:isDarkMode ? CookieJColors.customBlack : color[200],
      //主要用于内容显示部分的文字,黑白为主
      textTheme: TextTheme(
        //bodyText1: isDarkMode?CookieJTextStyle.middleTextWhite:CookieJTextStyle.middleText,
        bodyText2: isDarkMode?CookieJTextStyle.middleTextWhite:CookieJTextStyle.middleText,
        subtitle1: isDarkMode?CookieJTextStyle.middleTextWhite:CookieJTextStyle.middleText,
        subtitle2: isDarkMode?CookieJTextStyle.minText:CookieJTextStyle.minText.merge(TextStyle(color: Colors.grey[700])),
        
      ),
      //主要用于功能显示部分的文字
      primaryTextTheme: TextTheme(
        overline: TextStyle(fontSize:CookieJTextStyle.minTextSize,color:Colors.grey[600],letterSpacing: 0),
        bodyText1: CookieJTextStyle.middleTextWhite.merge(TextStyle(
          //color:luminance<0.15&&!isDarkMode?Colors.blue:color,
        )),
        bodyText2: CookieJTextStyle.middleText.merge(TextStyle(
          color:luminance<0.15&&!isDarkMode?Colors.blue:color,
        )),
        subtitle1: CookieJTextStyle.middleTextWhite,
        subtitle2: CookieJTextStyle.minText,
      )
    );
    if(color==CookieJColors.customWhite){
      theme=theme.copyWith(
        primaryColorBrightness: Brightness.light,
        toggleableActiveColor:Colors.red,
        primaryTextTheme: TextTheme(
          overline: TextStyle(fontSize:CookieJTextStyle.minTextSize,color:Colors.grey[600],letterSpacing: 0),
          bodyText1: CookieJTextStyle.middleTextWhite.merge(TextStyle(
            //color:luminance<0.15&&!isDarkMode?Colors.blue:color,
            color:Colors.blue
          )),
          bodyText2: CookieJTextStyle.middleText.merge(TextStyle(
            color:Colors.blue,
          )),
          subtitle1: CookieJTextStyle.middleTextWhite.copyWith(color:Colors.blue),
          subtitle2: CookieJTextStyle.minText.copyWith(color:Colors.blue),
        ),
      );
    }
    return theme;
  }

  static MaterialColor getMaterialColor(int colorValue){
    return MaterialColor(
      colorValue,
      <int,Color>{
        50: Color(colorValue),
        100:Color(colorValue),
        200:Color(colorValue),
        300:Color(colorValue),
        400:Color(colorValue),
        500:Color(colorValue),
        600:Color(colorValue),
        700:Color(colorValue),
        800:Color(colorValue),
        900:Color(colorValue),
      }
    );
  }

}

class CookieJTextStyle{
  static String mainFontFamily='思源宋体';
  static const String iconFontFamily='fontawesome'; 
  static const lagerTextSize = 24.0;
  static const bigTextSize = 20.0;
  static const normalTextSize = 18.0;
  static const middleTextWhiteSize = 16.0;
  static const smallTextSize = 14.0;
  static const minTextSize = 12.0;

  static const minText = TextStyle(
    color: CookieJColors.subTextColor,
    fontSize: minTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const smallTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: smallTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const smallText = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: smallTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const smallTextBold = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: smallTextSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const smallSubLightText = TextStyle(
    color: CookieJColors.subLightTextColor,
    fontSize: smallTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const smallActionLightText = TextStyle(
    color: CookieJColors.actionBlue,
    fontSize: smallTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const smallMiLightText = TextStyle(
    color: CookieJColors.miWhite,
    fontSize: smallTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const smallSubText = TextStyle(
    color: CookieJColors.subTextColor,
    fontSize: smallTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const middleText = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: middleTextWhiteSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const middleTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: middleTextWhiteSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const middleSubText = TextStyle(
    color: CookieJColors.subTextColor,
    fontSize: middleTextWhiteSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const middleSubLightText = TextStyle(
    color: CookieJColors.subLightTextColor,
    fontSize: middleTextWhiteSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const middleTextBold = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const middleTextWhiteBold = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const middleSubTextBold = TextStyle(
    color: CookieJColors.subTextColor,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const normalText = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: normalTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const normalTextBold = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const normalSubText = TextStyle(
    color: CookieJColors.white,
    fontSize: normalTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const normalTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: normalTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const normalTextMitWhiteBold = TextStyle(
    color: CookieJColors.miWhite,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const normalTextActionWhiteBold = TextStyle(
    color: CookieJColors.actionBlue,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const normalTextLight = TextStyle(
    color: CookieJColors.primaryLightValue,
    fontSize: normalTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const largeText = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: bigTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const largeTextBold = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const largeTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: bigTextSize,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const largeTextWhiteBold = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const largeLargeTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: lagerTextSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );

  static const largeLargeText = TextStyle(
    color: CookieJColors.primaryValue,
    fontSize: lagerTextSize,
    fontWeight: FontWeight.bold,
    fontFamilyFallback: [
      CookieJTextStyle.iconFontFamily
    ]
  );
}