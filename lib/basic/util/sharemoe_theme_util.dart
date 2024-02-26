import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharemoeTheme {
  static light() => ThemeData.light().copyWith(
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
            primaryTextTheme: TextTheme(
                titleLarge: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700),
                labelLarge:
                    TextStyle(fontWeight: FontWeight.w300, fontSize: 10.sp,color: Colors.black)),
            tabBarTheme: TabBarTheme(dividerHeight: 0,),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors.light,
        ],
      );

  static dark() => ThemeData.dark().copyWith(
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Color(0xff3C3F41)),
        primaryTextTheme: TextTheme(
            displayLarge: TextStyle(color: Colors.red),
            titleLarge: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
                fontWeight: FontWeight.w700),
            labelLarge: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 10.sp,
                color: Colors.white70)),
        tabBarTheme: TabBarTheme(
            dividerHeight: 0,
            labelColor: Colors.lightBlue,
            unselectedLabelColor: Colors.white70),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle()),
        splashColor: Color(0xff2B2B2B),
        highlightColor: Color(0xff2B2B2B),
        extensions: <ThemeExtension<dynamic>>[
          CustomColors.dark,
        ],
      );
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.navBarColor,
    required this.imageLoadingColor,
    required this.inputBarBackgroundColor,
    required this.suggestionBarColor,
    required this.sharemoePink,
    required this.collectionCreateIconColor,
    required this.collectionManageIconColor,
  });

  final Color? navBarColor;
  final Color? imageLoadingColor;
  final Color? inputBarBackgroundColor;
  final Color? suggestionBarColor;
  final Color? sharemoePink;
  final Color? collectionCreateIconColor;
  final Color? collectionManageIconColor;

  @override
  CustomColors copyWith(
      {Color? navBarColor,
      Color? imageLoadingColor,
      Color? searchBarBackgroundColor,
      Color? suggestionBarColor,
      Color? sharemoePink,
      Color? collectionCreateIconColor,
      Color? collectionManageIconColor}) {
    return CustomColors(
        navBarColor: navBarColor ?? this.navBarColor,
        imageLoadingColor: imageLoadingColor ?? this.imageLoadingColor,
        inputBarBackgroundColor:
            searchBarBackgroundColor ?? this.inputBarBackgroundColor,
        suggestionBarColor: suggestionBarColor ?? this.suggestionBarColor,
        sharemoePink: sharemoePink ?? this.sharemoePink,
        collectionCreateIconColor:
            collectionCreateIconColor ?? this.collectionCreateIconColor,
        collectionManageIconColor:
            collectionCreateIconColor ?? this.collectionCreateIconColor);
  }

  // Controls how the properties change on theme changes
  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
        navBarColor: Color.lerp(navBarColor, other.navBarColor, t),
        imageLoadingColor:
            Color.lerp(imageLoadingColor, other.imageLoadingColor, t),
        inputBarBackgroundColor: Color.lerp(
            inputBarBackgroundColor, other.inputBarBackgroundColor, t),
        suggestionBarColor:
            Color.lerp(suggestionBarColor, other.suggestionBarColor, t),
        sharemoePink: Color.lerp(sharemoePink, other.sharemoePink, t),
        collectionManageIconColor: Color.lerp(
            collectionManageIconColor, other.collectionManageIconColor, t),
        collectionCreateIconColor: Color.lerp(
            collectionCreateIconColor, other.collectionCreateIconColor, t));
  }

  // Controls how it displays when the instance is being passed
  // to the `print()` method.
  @override
  String toString() => 'CustomColors('
      'success: $navBarColor, info: $imageLoadingColor, warning: $imageLoadingColor, danger: $suggestionBarColor'
      ')';

  // the light theme
  static const light = CustomColors(
      navBarColor: Colors.white,
      imageLoadingColor: Colors.white,
      inputBarBackgroundColor: Color(0xfff4F3F3F3),
      suggestionBarColor: Color(0xffB9EEE5),
      sharemoePink: Color(0xffFFC0CB),
      collectionCreateIconColor: Colors.blue,
      collectionManageIconColor: Colors.green);

  // the dark theme
  static const dark = CustomColors(
      navBarColor: Color(0xff555758),
      imageLoadingColor: Color(0xff17a2b8),
      inputBarBackgroundColor: Color(0xff45494A),
      suggestionBarColor: Color(0xff9AC4BD),
      sharemoePink: Color(0xffD29FA9),
      collectionCreateIconColor: Color(0xff4CA5F0),
      collectionManageIconColor: Color(0xff6AB96E));
}
