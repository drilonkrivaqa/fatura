import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import 'hive_service.dart';

class SettingsService extends ChangeNotifier {
  AppSettings _settings = AppSettings(
    currencySymbol: '€',
    defaultVatRate: 0,
    defaultPaymentTerms: 14,
    lastInvoiceNumber: 0,
    themeMode: 'system',
    localeCode: 'en',
  );

  AppSettings get settings => _settings;

  SettingsService() {
    loadSettings();
  }

  ThemeMode get currentThemeMode {
    switch (_settings.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  void loadSettings() {
    final box = HiveService.settingsBox();
    try {
      if (box.isNotEmpty) {
        final storedSettings = box.getAt(0);
        if (storedSettings is AppSettings) {
          var updatedSettings = storedSettings;
          if (updatedSettings.themeMode.isEmpty) {
            updatedSettings = storedSettings.copyWith(themeMode: 'system');
            box.putAt(0, updatedSettings);
          }
          _settings = updatedSettings;
        } else {
          // Clear corrupt or incompatible value and persist defaults
          box.clear();
          box.add(_settings);
        }
      } else {
        box.add(_settings);
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to read settings, resetting to defaults: $error');
      debugPrintStack(stackTrace: stackTrace);
      box.clear();
      box.add(_settings);
    }
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings settings) async {
    final box = HiveService.settingsBox();
    if (box.isEmpty) {
      await box.add(settings);
    } else {
      await box.putAt(0, settings);
    }
    _settings = settings;
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    final newSettings = _settings.copyWith(themeMode: mode);
    await updateSettings(newSettings);
  }

  Future<void> setLocale(String localeCode) async {
    final newSettings = _settings.copyWith(localeCode: localeCode);
    await updateSettings(newSettings);
  }

  // Generates and persists the next invoice number in format INV-0001
  Future<String> getNextInvoiceNumber() async {
    final nextNumber = _settings.lastInvoiceNumber + 1;
    final formatted = 'INV-${nextNumber.toString().padLeft(4, '0')}';
    await updateSettings(_settings.copyWith(lastInvoiceNumber: nextNumber));
    return formatted;
  }
}
