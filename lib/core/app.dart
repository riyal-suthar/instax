import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:instax/core/multi_bloc_provider.dart';
import 'package:instax/core/resources/assets_manager.dart';
import 'package:instax/core/resources/color_manager.dart';
import 'package:instax/core/translations/app_lang.dart';
import 'package:instax/core/translations/translations.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/presentation/pages/register/sign_in_page.dart';
import 'package:get/get.dart';
import '../config/themes/app_theme.dart';
import '../config/themes/theme_service.dart';
import '../presentation/pages/register/widgets/get_my_user_info.dart';
import 'functions/initial_function.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _defineThePlatform(context);
    return MultiBlocs(materialApp(context));
  }

  Widget materialApp(BuildContext context) {
    return GetBuilder<AppLanguage>(
      init: AppLanguage.getInstance(),
      tag: AppLanguage.tag,
      builder: (controller) {
        return GetMaterialApp(
          defaultTransition: Transition.noTransition,
          transitionDuration: const Duration(seconds: 0),
          translations: Translation(),
          locale: Locale(controller.languageSelected),
          fallbackLocale: const Locale('en'),
          debugShowCheckedModeBanner: false,
          title: 'Instagram',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeOfApp.theme,
          home: animatedSplashScreen(),
        );
      },
    );
  }

  AnimatedSplashScreen animatedSplashScreen() {
    return AnimatedSplashScreen.withScreenFunction(
      screenFunction: screenFunction,
      centered: true,
      splash: IconsAssets.splashIcon,
      backgroundColor: ColorManager.white,
      splashTransition: SplashTransition.scaleTransition,
    );
  }

  Future<Widget> screenFunction() async {
    String? myId = await initializeDefaultValues();

    return myId == null
        ? const SignInPage()
        : GetMyPersonalInfo(myPersonalId: myId);
  }

  _defineThePlatform(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    isThatMobile =
        platform == TargetPlatform.iOS || platform == TargetPlatform.android;
    isThatAndroid = platform == TargetPlatform.android;
  }
}
