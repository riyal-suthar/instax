import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeOfApp {
  static final _box = GetStorage();
  static const _key = 'isDarkMode';
  static ThemeMode get theme =>
      isThemeDark() ? ThemeMode.dark : ThemeMode.light;

  static bool isThemeDark() => _box.read(_key) ?? false;

  static Future _saveThemeToBox() async =>
      await _box.write(_key, !isThemeDark());

  static Future<void> switchTheme() async {
    ThemeMode theme = isThemeDark() ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(theme);
    await _saveThemeToBox();
  }
}
