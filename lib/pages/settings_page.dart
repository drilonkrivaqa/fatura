import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../l10n/app_localizations.dart';
import '../models/app_settings.dart';
import '../models/company_profile.dart';
import '../services/company_service.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
  String? _editingCompanyId;

  late TextEditingController _currencyController;
  late TextEditingController _vatController;
  late TextEditingController _termsController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _taxController = TextEditingController();
    _bankController = TextEditingController();
    _ibanController = TextEditingController();
    _websiteController = TextEditingController();

    final company = context.read<CompanyService>().profile;
    _applyCompanyToForm(company);

    final settings = context.read<SettingsService>().settings;
    _currencyController = TextEditingController(text: settings.currencySymbol);
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

  void _applyCompanyToForm(CompanyProfile? company) {
    _editingCompanyId = company?.id;
    _nameController.text = company?.name ?? '';
    _addressController.text = company?.address ?? '';
    _cityController.text = company?.city ?? '';
    _countryController.text = company?.country ?? '';
    _phoneController.text = company?.phone ?? '';
    _emailController.text = company?.email ?? '';
    _taxController.text = company?.taxNumber ?? '';
    _bankController.text = company?.bankName ?? '';
    _ibanController.text = company?.iban ?? '';
    _websiteController.text = company?.website ?? '';
    _logoPath = company?.logoPath ?? '';
  }

  void _resetCompanyForm() {
    _editingCompanyId = null;
    _nameController.clear();
    _addressController.clear();
    _cityController.clear();
    _countryController.clear();
    _phoneController.clear();
    _emailController.clear();
    _taxController.clear();
    _bankController.clear();
    _ibanController.clear();
    _websiteController.clear();
    _logoPath = '';
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      final picked = result.files.single;

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

  CompanyProfile _companyFromForm({String? forcedId}) {
    return CompanyProfile(
      id: forcedId ?? _editingCompanyId ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      taxNumber: _taxController.text.trim(),
      bankName: _bankController.text.trim(),
      iban: _ibanController.text.trim(),
      website: _websiteController.text.trim(),
      logoPath: _logoPath,
    );
  }

  Future<void> _saveDefaults(SettingsService settingsService) async {
    final newSettings = AppSettings(
      currencySymbol: _currencyController.text,
      defaultVatRate: double.tryParse(_vatController.text) ?? 0,
      defaultPaymentTerms: int.tryParse(_termsController.text) ?? 0,
      lastInvoiceNumber: settingsService.settings.lastInvoiceNumber,
      themeMode: settingsService.settings.themeMode,
      localeCode: settingsService.settings.localeCode,
    );
    await settingsService.updateSettings(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();
    final companyService = context.watch<CompanyService>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                context.l10n.tr('companyProfiles'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _editingCompanyId,
                      hint: Text(context.l10n.tr('selectCompanyToEdit')),
                      items: companyService.companies
                          .map(
                            (c) => DropdownMenuItem<String>(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        CompanyProfile? selected;
                        for (final company in companyService.companies) {
                          if (company.id == value) {
                            selected = company;
                            break;
                          }
                        }
                        setState(() {
                          _applyCompanyToForm(selected);
                        });
                        companyService.selectCompany(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => setState(_resetCompanyForm),
                    icon: const Icon(Icons.add_business_outlined),
                    label: Text(context.l10n.tr('new')),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickLogo,
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage: _logoProvider(),
                      child: _logoPath.isEmpty
                          ? const Icon(Icons.add_a_photo)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: _pickLogo,
                    icon: const Icon(Icons.upload),
                    label: Text(context.l10n.tr('uploadLogo')),
                  )
                ],
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: context.l10n.tr('companyName')),
                validator: (val) =>
                    val == null || val.isEmpty ? context.l10n.tr('required') : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: context.l10n.tr('address')),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: context.l10n.tr('city')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: InputDecoration(labelText: context.l10n.tr('country')),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: context.l10n.tr('phone')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: context.l10n.tr('email')),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _taxController,
                decoration: InputDecoration(labelText: context.l10n.tr('taxNumber')),
              ),
              TextFormField(
                controller: _bankController,
                decoration: InputDecoration(labelText: context.l10n.tr('bankName')),
              ),
              TextFormField(
                controller: _ibanController,
                decoration: const InputDecoration(labelText: 'IBAN'),
              ),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: context.l10n.tr('website')),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() != true) return;
                      await companyService.upsertCompany(_companyFromForm());
                      await _saveDefaults(settingsService);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.tr('companySaved'))),
                        );
                      }
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: Text(
                      _editingCompanyId == null
                          ? context.l10n.tr('saveCompany')
                          : context.l10n.tr('updateCompany'),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() != true) return;
                      final company = _companyFromForm(forcedId: const Uuid().v4());
                      await companyService.upsertCompany(company);

                      if (mounted) {
                        setState(() => _editingCompanyId = company.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.tr('savedAsNewCompany'))),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy_outlined),
                    label: Text(context.l10n.tr('saveAsNew')),
                  ),
                  if (_editingCompanyId != null)
                    OutlinedButton.icon(
                      onPressed: () async {
                        final companyName = _nameController.text;
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(context.l10n.tr('deleteCompany')),
                            content: Text(
                              context.l10n.trf('deleteCompanyConfirm', {'name': companyName}),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(context.l10n.tr('cancel')),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(context.l10n.tr('delete')),
                              ),
                            ],
                          ),
                        );
                        if (shouldDelete == true) {
                          await companyService.deleteCompany(_editingCompanyId!);
                          setState(_resetCompanyForm);
                        }
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: Text(context.l10n.tr('deleteCompany')),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.tr('defaults'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _currencyController,
                      decoration: InputDecoration(
                        labelText: context.l10n.tr('currencySymbol'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _vatController,
                      decoration: InputDecoration(
                        labelText: context.l10n.tr('defaultVat'),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _termsController,
                      decoration: InputDecoration(
                        labelText: context.l10n.tr('paymentTermsDays'),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.tr('language'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: settingsService.settings.localeCode,
                items: [
                  DropdownMenuItem(value: 'en', child: Text(context.l10n.tr('english'))),
                  DropdownMenuItem(value: 'sq', child: Text(context.l10n.tr('albanian'))),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsService>().setLocaleCode(value);
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.tr('appearanceTheme'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                title: Text(context.l10n.tr('system')),
                value: 'system',
                groupValue: settingsService.settings.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsService>().setThemeMode(value);
                  }
                },
              ),
              RadioListTile<String>(
                title: Text(context.l10n.tr('light')),
                value: 'light',
                groupValue: settingsService.settings.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsService>().setThemeMode(value);
                  }
                },
              ),
              RadioListTile<String>(
                title: Text(context.l10n.tr('dark')),
                value: 'dark',
                groupValue: settingsService.settings.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingsService>().setThemeMode(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  await _saveDefaults(settingsService);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.tr('defaultsSaved'))),
                    );
                  }
                },
                child: Text(context.l10n.tr('saveDefaults')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
