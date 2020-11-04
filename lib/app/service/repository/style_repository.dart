import 'dart:io';

import 'package:flutter/material.dart';

class StyleRepository {
  static TextStyle _baseTextStyle =
      TextStyle(fontFamilyFallback: [StyleFonts.iconFontFamily]);

  static ThemeData getThemeData(String themeName, {bool isDarkMode = false}) {
    MaterialColor color = StyleColors.themeColors[themeName];
    //颜色的亮度，涉及夜间模式下深色主题的活动颜色设置
    double luminance = color.computeLuminance();
    color = luminance < 0.15 && isDarkMode ? Colors.teal : color;

    var theme = ThemeData(
        primarySwatch: color,
        platform: Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        //主颜色属于暗色还是亮色，关乎到文本的黑或白
        primaryColorBrightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        //选中文本时的背景颜色,
        textSelectionHandleColor: color.shade300,
        //画布颜色(背景色)
        canvasColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
        //前景色
        accentColor: color.shade600,
        //用于突出显示切换Widget（如Switch，Radio和Checkbox）的活动状态的颜色。
        dialogBackgroundColor:
            isDarkMode ? StyleColors.customBlackDeep : Colors.white,
        toggleableActiveColor: color.shade500,
        unselectedWidgetColor:
            isDarkMode ? StyleColors.customBlack : StyleColors.customWhite,
        //主要用于内容显示部分的文字,黑白为主
        textTheme: TextTheme(
            bodyText1: _baseTextStyle.merge(TextStyle(
                fontSize: StyleFonts.middleTextSize,
                color: isDarkMode ? Colors.grey[200] : Colors.grey[700])),
            bodyText2: _baseTextStyle.merge(TextStyle(
                fontSize: StyleFonts.middleTextSize,
                color: isDarkMode ? Colors.white : Colors.black)),
            subtitle1: _baseTextStyle.merge(TextStyle(
                fontSize: StyleFonts.smallTextSize,
                color: isDarkMode ? Colors.grey[200] : Colors.grey[700])),
            subtitle2: _baseTextStyle.merge(TextStyle(
                fontSize: StyleFonts.minTextSize,
                color: isDarkMode ? Colors.grey[200] : Colors.grey[700])),
            overline: _baseTextStyle.merge(TextStyle(
                fontSize: StyleFonts.minTextSize,
                color: Colors.grey[600],
                letterSpacing: 0))),
        // 带颜色，透明度文字,背景为彩色的文字显示颜色
        primaryTextTheme: TextTheme(
          bodyText1: _baseTextStyle.merge(TextStyle(
              fontSize: StyleFonts.middleTextSize,
              color: luminance < 0.15 && isDarkMode
                  ? Colors.white
                  : Colors.black)),
          bodyText2: _baseTextStyle.merge(TextStyle(
              fontSize: StyleFonts.middleTextSize,
              color: luminance < 0.15 && !isDarkMode ? Colors.blue : color)),
          subtitle1: _baseTextStyle.merge(
              TextStyle(fontSize: StyleFonts.smallTextSize, color: color)),
          subtitle2: _baseTextStyle
              .merge(TextStyle(fontSize: StyleFonts.minTextSize, color: color)),
        ));
    return theme;
  }
}

class StyleFonts {
  static String mainFontFamily = '思源宋体';
  static const String iconFontFamily = 'fontawesome';
  static const maxTextSize = 24.0;
  static const lagerTextSize = 20.0;
  static const bigTextSize = 18.0;
  static const middleTextSize = 16.0;
  static const smallTextSize = 14.0;
  static const minTextSize = 12.0;
}

class StyleColors {
  static const Color customWhite = Color(0xFFFEFEFE);
  static const Color girlPink = Color(0xFFFA7298);
  static const Color customBlack = Color(0xFF292929);
  static const Color customBlackDeep = Color(0xFF252525);
  static const Color salmonPink = Color(0xFFFA8072);
  static const Color apricot = Color(0xFFF8B878);

  static final Map<String, MaterialColor> themeColors = {
    '默认白': _getMaterialColor(customWhite.value),
    '谷歌蓝': Colors.blue,
    '薄荷绿': Colors.teal,
    '经典黑': _getMaterialColor(customBlack.value),
    '琥珀黄': Colors.amber,
    '钢蓝灰': Colors.blueGrey,
    '胡萝卜': Colors.orange,
    '天空蓝': Colors.cyan,
    '中国红': Colors.red,
    '鲑鱼粉': _getMaterialColor(salmonPink.value),
    '杏黄色': _getMaterialColor(apricot.value),
    '少女粉': _getMaterialColor(girlPink.value),
  };

  static MaterialColor _getMaterialColor(int colorValue) {
    return MaterialColor(colorValue, <int, Color>{
      50: Color(colorValue),
      100: Color(colorValue),
      200: Color(colorValue),
      300: Color(colorValue),
      400: Color(colorValue),
      500: Color(colorValue),
      600: Color(colorValue),
      700: Color(colorValue),
      800: Color(colorValue),
      900: Color(colorValue),
    });
  }
}
