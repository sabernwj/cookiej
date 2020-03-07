import 'package:cookiej/cookiej/action/theme_state.dart';
import 'package:cookiej/cookiej/reducer/theme_reducer.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class CookieJColors{
  
  static const List<Color> themeColors= <Color>[
      CookieJColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
  ];
  static const int primaryIntValue = 0xFF24292E;
  static const MaterialColor primarySwatch = const MaterialColor(
    primaryIntValue,
    const <int, Color>{
      50: const Color(primaryIntValue),
      100: const Color(primaryIntValue),
      200: const Color(primaryIntValue),
      300: const Color(primaryIntValue),
      400: const Color(primaryIntValue),
      500: const Color(primaryIntValue),
      600: const Color(primaryIntValue),
      700: const Color(primaryIntValue),
      800: const Color(primaryIntValue),
      900: const Color(primaryIntValue),
    },
  ); 
  static const Color primaryValue = Color(0xFF24292E);
  static const Color primaryLightValue = Color(0xFF42464b);
  static const Color primaryDarkValue = Color(0xFF121917);

  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color miWhite = Color(0xffececec);
  static const Color white = Color(0xFFFFFFFF);
  static const Color actionBlue = Color(0xff267aff);
  static const Color subTextColor = Color(0xff959595);
  static const Color subLightTextColor = Color(0xffc4c4c4);

  static const Color mainBackgroundColor = miWhite;

  static const Color mainTextColor = primaryDarkValue;
  static const Color textColorWhite = white;

  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = CookieJColors.themeColors;
    themeData = getThemeData(colors[index]);
    store.dispatch(RefreshThemeDataAction(themeData));
  }

  static getThemeData(Color color) {
    return ThemeData(primarySwatch: color, platform: TargetPlatform.android);
  }

}

class CookieJTextStyle{
  static const lagerTextSize = 30.0;
  static const bigTextSize = 23.0;
  static const normalTextSize = 18.0;
  static const middleTextWhiteSize = 16.0;
  static const smallTextSize = 14.0;
  static const minTextSize = 12.0;

  static const minText = TextStyle(
    
    color: CookieJColors.subLightTextColor,
    fontSize: minTextSize,
    fontFamily: 'fontawesome',
  );

  static const smallTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: smallTextSize,
    fontFamily: 'fontawesome',
  );

  static const smallText = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: smallTextSize,
    fontFamily: 'fontawesome',
  );

  static const smallTextBold = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: smallTextSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const smallSubLightText = TextStyle(
    color: CookieJColors.subLightTextColor,
    fontSize: smallTextSize,
    fontFamily: 'fontawesome',
  );

  static const smallActionLightText = TextStyle(
    color: CookieJColors.actionBlue,
    fontSize: smallTextSize,
    fontFamily: 'fontawesome',
  );

  static const smallMiLightText = TextStyle(
    color: CookieJColors.miWhite,
    fontSize: smallTextSize,
    fontFamily: 'fontawesome',
  );

  static const smallSubText = TextStyle(
    color: CookieJColors.subTextColor,
    fontSize: smallTextSize,
    fontFamily: 'fontawesome',
  );

  static const middleText = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: middleTextWhiteSize,
    fontFamily: 'fontawesome',
  );

  static const middleTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: middleTextWhiteSize,
    fontFamily: 'fontawesome',
  );

  static const middleSubText = TextStyle(
    color: CookieJColors.subTextColor,
    fontSize: middleTextWhiteSize,
    fontFamily: 'fontawesome',
  );

  static const middleSubLightText = TextStyle(
    color: CookieJColors.subLightTextColor,
    fontSize: middleTextWhiteSize,
    fontFamily: 'fontawesome',
  );

  static const middleTextBold = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const middleTextWhiteBold = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const middleSubTextBold = TextStyle(
    color: CookieJColors.subTextColor,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const normalText = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: normalTextSize,
    fontFamily: 'fontawesome',
  );

  static const normalTextBold = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const normalSubText = TextStyle(
    color: CookieJColors.subTextColor,
    fontSize: normalTextSize,
    fontFamily: 'fontawesome',
  );

  static const normalTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: normalTextSize,
    fontFamily: 'fontawesome',
  );

  static const normalTextMitWhiteBold = TextStyle(
    color: CookieJColors.miWhite,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const normalTextActionWhiteBold = TextStyle(
    color: CookieJColors.actionBlue,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const normalTextLight = TextStyle(
    color: CookieJColors.primaryLightValue,
    fontSize: normalTextSize,
    fontFamily: 'fontawesome',
  );

  static const largeText = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: bigTextSize,
    fontFamily: 'fontawesome',
  );

  static const largeTextBold = TextStyle(
    color: CookieJColors.mainTextColor,
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const largeTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: bigTextSize,
    fontFamily: 'fontawesome',
  );

  static const largeTextWhiteBold = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const largeLargeTextWhite = TextStyle(
    color: CookieJColors.textColorWhite,
    fontSize: lagerTextSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );

  static const largeLargeText = TextStyle(
    color: CookieJColors.primaryValue,
    fontSize: lagerTextSize,
    fontWeight: FontWeight.bold,
    fontFamily: 'fontawesome',
  );
}