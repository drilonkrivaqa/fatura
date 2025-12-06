import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import 'hive_service.dart';

class SettingsService extends ChangeNotifier {
  AppSettings _settings = AppSettings(
    currencySymbol: '€',
    defaultVatRate: 0,
    defaultPaymentTerms: 14,
    lastInvoiceNumber: 0,
  );

  AppSettings get settings => _settings;

  SettingsService() {
    loadSettings();
  }

  void loadSettings() {
    final box = HiveService.settingsBox();
    if (box.isNotEmpty) {
      final storedSettings = box.getAt(0);
      if (storedSettings is AppSettings) {
        _settings = storedSettings;
      } else {
        // Clear corrupt or incompatible value and persist defaults
        box.clear();
        box.add(_settings);
      }
    } else {
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

  // Generates and persists the next invoice number in format INV-0001
  Future<String> getNextInvoiceNumber() async {
    final nextNumber = _settings.lastInvoiceNumber + 1;
    final formatted = 'INV-${nextNumber.toString().padLeft(4, '0')}';
    await updateSettings(_settings.copyWith(lastInvoiceNumber: nextNumber));
    return formatted;
  }
}
