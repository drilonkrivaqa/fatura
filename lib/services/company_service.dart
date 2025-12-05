import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../models/company_profile.dart';
import 'hive_service.dart';

class CompanyService extends ChangeNotifier {
  CompanyProfile? _profile;

  CompanyProfile? get profile => _profile;

  CompanyService() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final box = HiveService.companyBox();
    if (box.isNotEmpty) {
      _profile = box.getAt(0);
    }
    notifyListeners();
  }

  Future<void> updateProfile(CompanyProfile profile) async {
    final box = HiveService.companyBox();
    if (box.isEmpty) {
      await box.add(profile);
    } else {
      await box.putAt(0, profile);
    }
    _profile = profile;
    notifyListeners();
  }

  // Copies the logo to application directory so the path remains valid
  Future<String> saveLogoFile(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.split('/').last;
    final newPath = '${directory.path}/$fileName';
    final originalFile = File(path);
    if (await originalFile.exists()) {
      await originalFile.copy(newPath);
    }
    return newPath;
  }
}
