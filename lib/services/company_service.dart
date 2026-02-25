import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/company_profile.dart';
import 'hive_service.dart';

class CompanyService extends ChangeNotifier {
  List<CompanyProfile> _companies = [];
  String? _selectedCompanyId;

  List<CompanyProfile> get companies => _companies;
  String? get selectedCompanyId => _selectedCompanyId;
  CompanyProfile? get selectedCompany {
    if (_companies.isEmpty) return null;
    return _companies.firstWhere(
      (company) => company.id == _selectedCompanyId,
      orElse: () => _companies.first,
    );
  }

  // Backward compatibility for old call sites.
  CompanyProfile? get profile => selectedCompany;

  CompanyService() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final box = HiveService.companyBox();
    _companies = box.values
        .map((company) => company.id.isEmpty
            ? company.copyWith(id: const Uuid().v4())
            : company)
        .toList();

    if (_companies.isNotEmpty) {
      _selectedCompanyId = _selectedCompanyId ?? _companies.first.id;

      await box.clear();
      for (final company in _companies) {
        await box.put(company.id, company);
      }
    }
    notifyListeners();
  }

  Future<void> updateProfile(CompanyProfile profile) async {
    final box = HiveService.companyBox();
    await box.put(profile.id, profile);

    final existingIndex = _companies.indexWhere((c) => c.id == profile.id);
    if (existingIndex >= 0) {
      _companies[existingIndex] = profile;
    } else {
      _companies.add(profile);
    }

    _selectedCompanyId = profile.id;
    notifyListeners();
  }

  Future<void> selectCompany(String? companyId) async {
    if (companyId == null || companyId == _selectedCompanyId) return;
    _selectedCompanyId = companyId;
    notifyListeners();
  }

  CompanyProfile? findById(String id) {
    try {
      return _companies.firstWhere((company) => company.id == id);
    } catch (_) {
      return null;
    }
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
