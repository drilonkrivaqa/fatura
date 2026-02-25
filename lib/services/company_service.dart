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
