import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/company_profile.dart';
import 'hive_service.dart';

class CompanyService extends ChangeNotifier {
  List<CompanyProfile> _companies = [];
  String? _selectedCompanyId;

  List<CompanyProfile> get companies => List.unmodifiable(_companies);

  CompanyProfile? get profile {
    if (_companies.isEmpty) {
      return null;
    }
    if (_selectedCompanyId == null) {
      return _companies.first;
    }
    for (final company in _companies) {
      if (company.id == _selectedCompanyId) return company;
    }
    return _companies.first;
  }

  CompanyService() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final box = HiveService.companyBox();
    final existingCompanies = box.values.toList();
    final hadMissingIds = existingCompanies.any((company) => company.id.isEmpty);
    _companies = existingCompanies
        .map(
          (company) => company.id.isEmpty
              ? company.copyWith(id: const Uuid().v4())
              : company,
        )
        .toList();

    if (_companies.isNotEmpty) {
      if (hadMissingIds) {
        await box.clear();
        for (final company in _companies) {
          await box.add(company);
        }
      }
      _selectedCompanyId = _companies.first.id;
    }

    notifyListeners();
  }

  Future<void> upsertCompany(
    CompanyProfile company, {
    bool setAsSelected = true,
  }) async {
    final id = company.id.isEmpty ? const Uuid().v4() : company.id;
    final normalized = company.copyWith(id: id);

    final index = _companies.indexWhere((c) => c.id == id);
    if (index >= 0) {
      _companies[index] = normalized;
    } else {
      _companies.add(normalized);
    }

    final box = HiveService.companyBox();
    await box.clear();
    for (final currentCompany in _companies) {
      await box.add(currentCompany);
    }

    if (setAsSelected) {
      _selectedCompanyId = id;
    }

    notifyListeners();
  }

  void selectCompany(String? id) {
    _selectedCompanyId = id;
    notifyListeners();
  }

  Future<void> deleteCompany(String id) async {
    _companies.removeWhere((c) => c.id == id);

    final box = HiveService.companyBox();
    await box.clear();
    for (final currentCompany in _companies) {
      await box.add(currentCompany);
    }

    if (_selectedCompanyId == id) {
      _selectedCompanyId = _companies.isEmpty ? null : _companies.first.id;
    }

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
