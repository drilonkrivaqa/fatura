import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../l10n.dart';
import '../models/client.dart';
import '../services/client_service.dart';

class ClientFormPage extends StatefulWidget {
  final bool isEditing;
  final Client? client;

  const ClientFormPage({super.key, required this.isEditing, this.client});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _taxController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _addressController = TextEditingController(text: widget.client?.address ?? '');
    _cityController = TextEditingController(text: widget.client?.city ?? '');
    _countryController = TextEditingController(text: widget.client?.country ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _taxController = TextEditingController(text: widget.client?.taxNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditing ? context.t('Edit client') : context.t('Create client'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: context.t('Client name')),
                validator: (val) => val == null || val.isEmpty ? context.t('Required') : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: context.t('Address')),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: context.t('City')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: InputDecoration(labelText: context.t('Country')),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: context.t('Email')),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: context.t('Phone')),
              ),
              TextFormField(
                controller: _taxController,
                decoration: InputDecoration(labelText: context.t('Tax number')),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() != true) return;
                  final client = Client(
                    id: widget.client?.id ?? const Uuid().v4(),
                    name: _nameController.text,
                    address: _addressController.text,
                    city: _cityController.text,
                    country: _countryController.text,
                    email: _emailController.text,
                    phone: _phoneController.text,
                    taxNumber: _taxController.text,
                  );
                  final service = context.read<ClientService>();
                  if (widget.isEditing) {
                    await service.updateClient(client);
                  } else {
                    await service.addClient(client);
                  }
                  if (mounted) Navigator.pop(context);
                },
                child: Text(widget.isEditing ? context.t('Update') : context.t('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
