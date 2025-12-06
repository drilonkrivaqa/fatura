import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_settings.dart';
import '../models/company_profile.dart';
import '../services/company_service.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State createState() => _SettingsPageState();
}

class _SettingsPageState extends State {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _taxController;
  late TextEditingController _bankController;
  late TextEditingController _ibanController;
  late TextEditingController _websiteController;
  String _logoPath = '';

  late TextEditingController _currencyController;
  late TextEditingController _vatController;
  late TextEditingController _termsController;

  @override
  void initState() {
    super.initState();

    // ✅ Typed provider
    final company = context.read<CompanyService>().profile;

    _nameController = TextEditingController(text: company?.name ?? '');
    _addressController = TextEditingController(text: company?.address ?? '');
    _cityController = TextEditingController(text: company?.city ?? '');
    _countryController = TextEditingController(text: company?.country ?? '');
    _phoneController = TextEditingController(text: company?.phone ?? '');
    _emailController = TextEditingController(text: company?.email ?? '');
    _taxController = TextEditingController(text: company?.taxNumber ?? '');
    _bankController = TextEditingController(text: company?.bankName ?? '');
    _ibanController = TextEditingController(text: company?.iban ?? '');
    _websiteController = TextEditingController(text: company?.website ?? '');
    _logoPath = company?.logoPath ?? '';

    // ✅ Typed provider
    final settings = context.read<SettingsService>().settings;
    _currencyController =
        TextEditingController(text: settings.currencySymbol);
    _vatController =
        TextEditingController(text: settings.defaultVatRate.toString());
    _termsController =
        TextEditingController(text: settings.defaultPaymentTerms.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _taxController.dispose();
    _bankController.dispose();
    _ibanController.dispose();
    _websiteController.dispose();
    _currencyController.dispose();
    _vatController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future _pickLogo() async {
    final result =
        await FilePicker.platform.pickFiles(type: FileType.image, withData: true);

    if (result != null) {
      final picked = result.files.single;

      // ✅ Typed provider
      final service = context.read<CompanyService>();
      final savedPath = await service.saveLogoFile(
        originalPath: picked.path,
        bytes: picked.bytes,
        fileName: picked.name,
      );

      setState(() {
        _logoPath = savedPath;
      });
    }
  }

  ImageProvider? _logoProvider() {
    if (_logoPath.isEmpty) return null;

    if (kIsWeb && _logoPath.startsWith('data:')) {
      final encoded = _logoPath.split(',').last;
      return MemoryImage(base64Decode(encoded));
    }

    final file = File(_logoPath);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Typed provider
    final settingsService = context.watch<SettingsService>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Company profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickLogo,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: _logoProvider(),
                      child:
                          _logoPath.isEmpty ? const Icon(Icons.add_a_photo) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: _pickLogo,
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload logo'),
                  )
                ],
              ),
              TextFormField(
                controller: _nameController,
                decoration:
                const InputDecoration(labelText: 'Company name'),
                validator: (val) =>
                val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration:
                const InputDecoration(labelText: 'Address'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration:
                      const InputDecoration(labelText: 'City'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration:
                      const InputDecoration(labelText: 'Country'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration:
                      const InputDecoration(labelText: 'Phone'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration:
                      const InputDecoration(labelText: 'Email'),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _taxController,
                decoration:
                const InputDecoration(labelText: 'Tax number'),
              ),
              TextFormField(
                controller: _bankController,
                decoration:
                const InputDecoration(labelText: 'Bank name'),
              ),
              TextFormField(
                controller: _ibanController,
                decoration:
                const InputDecoration(labelText: 'IBAN'),
              ),
              TextFormField(
                controller: _websiteController,
                decoration:
                const InputDecoration(labelText: 'Website'),
              ),
              const SizedBox(height: 16),
              Text(
                'Defaults',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _currencyController,
                      decoration: const InputDecoration(
                        labelText: 'Currency symbol',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _vatController,
                      decoration: const InputDecoration(
                        labelText: 'Default VAT %',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _termsController,
                      decoration: const InputDecoration(
                        labelText: 'Payment terms (days)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() != true) return;

                  final companyProfile = CompanyProfile(
                    name: _nameController.text,
                    address: _addressController.text,
                    city: _cityController.text,
                    country: _countryController.text,
                    phone: _phoneController.text,
                    email: _emailController.text,
                    taxNumber: _taxController.text,
                    bankName: _bankController.text,
                    iban: _ibanController.text,
                    website: _websiteController.text,
                    logoPath: _logoPath,
                  );

                  // ✅ Typed provider
                  await context
                      .read<CompanyService>()
                      .updateProfile(companyProfile);

                  final newSettings = AppSettings(
                    currencySymbol: _currencyController.text,
                    defaultVatRate:
                    double.tryParse(_vatController.text) ?? 0,
                    defaultPaymentTerms:
                    int.tryParse(_termsController.text) ?? 0,
                    lastInvoiceNumber:
                    settingsService.settings.lastInvoiceNumber,
                  );

                  await settingsService.updateSettings(newSettings);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings saved'),
                      ),
                    );
                  }
                },
                child: const Text('Save settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
