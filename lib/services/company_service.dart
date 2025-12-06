import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/company_profile.dart';
import 'hive_service.dart';

class CompanyService extends ChangeNotifier {
  List<CompanyProfile> _companies = [];
  int? _activeIndex;

  List<CompanyProfile> get companies => _companies;

  CompanyProfile? get activeProfile =>
      _activeIndex != null && _activeIndex! >= 0 && _activeIndex! < _companies.length
          ? _companies[_activeIndex!]
          : null;

  int? get activeIndex => _activeIndex;

  CompanyService() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final box = HiveService.companyBox();
    final metaBox = HiveService.metaBox();

    _companies = box.values.toList();
    _activeIndex = metaBox.get(HiveService.activeCompanyKey);

    if (_activeIndex != null &&
        (_activeIndex! < 0 || _activeIndex! >= _companies.length)) {
      _activeIndex = null;
    }

    if (_activeIndex == null && _companies.length == 1) {
      _activeIndex = 0;
      await _persistActiveIndex();
    }

    notifyListeners();
  }

  Future<void> addCompany(CompanyProfile profile) async {
    final box = HiveService.companyBox();
    await box.add(profile);
    _companies = box.values.toList();
    _activeIndex = _companies.isNotEmpty ? _companies.length - 1 : null;
    await _persistActiveIndex();
    notifyListeners();
  }

  Future<void> updateCompany(int index, CompanyProfile profile) async {
    final box = HiveService.companyBox();
    if (index < 0 || index >= box.length) return;
    await box.putAt(index, profile);
    _companies[index] = profile;
    notifyListeners();
  }

  Future<void> deleteCompany(int index) async {
    final box = HiveService.companyBox();
    if (index < 0 || index >= box.length) return;
    await box.deleteAt(index);
    _companies = box.values.toList();

    if (_activeIndex != null) {
      if (_companies.isEmpty) {
        _activeIndex = null;
      } else if (_activeIndex == index) {
        _activeIndex = index.clamp(0, _companies.length - 1).toInt();
      } else if (_activeIndex! > index) {
        _activeIndex = _activeIndex! - 1;
      }
      await _persistActiveIndex();
    }

    notifyListeners();
  }

  Future<void> setActiveCompany(int index) async {
    if (index < 0 || index >= _companies.length) return;
    _activeIndex = index;
    await _persistActiveIndex();
    notifyListeners();
  }

  // Copies the logo to application directory so the path remains valid
  Future<String> saveLogoFile({
    String? originalPath,
    Uint8List? bytes,
    String? fileName,
  }) async {
    if (kIsWeb) {
      if (bytes == null) return '';
      final mime = _mimeType(fileName ?? originalPath);
      final encoded = base64Encode(bytes);
      return 'data:$mime;base64,$encoded';
    }

    final directory = await getApplicationDocumentsDirectory();
    final safeFileName = fileName ??
        (originalPath != null ? p.basename(originalPath) : 'logo.png');
    final newPath = p.join(directory.path, safeFileName);

    if (bytes != null) {
      await File(newPath).writeAsBytes(bytes, flush: true);
      return newPath;
    }

    if (originalPath != null) {
      final originalFile = File(originalPath);
      if (await originalFile.exists()) {
        await originalFile.copy(newPath);
      }
    }
    return newPath;
  }

  Future<void> _persistActiveIndex() async {
    final metaBox = HiveService.metaBox();
    if (_activeIndex == null) {
      await metaBox.delete(HiveService.activeCompanyKey);
    } else {
      await metaBox.put(HiveService.activeCompanyKey, _activeIndex!);
    }
  }

  String _mimeType(String? path) {
    final extension = (path != null ? p.extension(path) : '').toLowerCase();
    switch (extension) {
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.gif':
        return 'image/gif';
      default:
        return 'application/octet-stream';
    }
  }
}
