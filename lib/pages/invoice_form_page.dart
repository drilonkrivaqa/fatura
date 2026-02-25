import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../l10n/app_localizations.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../models/company_profile.dart';
import '../services/client_service.dart';
import '../services/company_service.dart';
import '../services/invoice_service.dart';
import '../services/settings_service.dart';
import '../utils/number_to_words.dart';

class InvoiceFormPage extends StatefulWidget {
  final Invoice? existingInvoice;

  const InvoiceFormPage({
    super.key,
    this.existingInvoice,
  });

  @override
  State createState() => _InvoiceFormPageState();
}

class _InvoiceFormPageState extends State<InvoiceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedClientId;
  String? _selectedCompanyId;
  bool _useManualClient = false;
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now();
  String _paymentTerms = '';
  double _vatRate = 0;
  InvoiceStatus _status = InvoiceStatus.unpaid;

  late final TextEditingController _manualNameController;
  late final TextEditingController _manualAddressController;
  late final TextEditingController _manualCityController;
  late final TextEditingController _manualCountryController;
  late final TextEditingController _manualEmailController;
  late final TextEditingController _manualPhoneController;
  late final TextEditingController _manualTaxNumberController;

  List<InvoiceItem> _items = [];
  double _subtotal = 0;
  double _vatAmount = 0;
  double _total = 0;
  String _totalInWords = '';
  String _currencyWord = 'euro';

  @override
  void initState() {
    super.initState();

    _manualNameController = TextEditingController();
    _manualAddressController = TextEditingController();
    _manualCityController = TextEditingController();
    _manualCountryController = TextEditingController();
    _manualEmailController = TextEditingController();
    _manualPhoneController = TextEditingController();
    _manualTaxNumberController = TextEditingController();

    final settings = context.read<SettingsService>().settings;

    if (widget.existingInvoice != null) {
      final invoice = widget.existingInvoice!;
      _selectedClientId = invoice.clientId.isNotEmpty ? invoice.clientId : null;
      _selectedCompanyId = invoice.companyId.isNotEmpty ? invoice.companyId : null;
      _useManualClient = invoice.clientId.isEmpty;
      _invoiceDate = invoice.date;
      _dueDate = invoice.dueDate;
      _paymentTerms = invoice.paymentTerms;
      _vatRate = invoice.vatRate;
      _status = invoice.status;
      _items = invoice.items.map((item) => item.copyWith()).toList();
      _currencyWord = invoice.currency == '€' ? 'euro' : invoice.currency;

      _manualNameController.text = invoice.clientName;
      _manualAddressController.text = invoice.clientAddress;
      _manualCityController.text = invoice.clientCity;
      _manualCountryController.text = invoice.clientCountry;
      _manualEmailController.text = invoice.clientEmail;
      _manualPhoneController.text = invoice.clientPhone;
      _manualTaxNumberController.text = invoice.clientTaxNumber;
    } else {
      _selectedCompanyId = context.read<CompanyService>().profile?.id;
      _vatRate = settings.defaultVatRate;
      _paymentTerms = _paymentTermsValue(settings.defaultPaymentTerms);
      _dueDate =
          _invoiceDate.add(Duration(days: settings.defaultPaymentTerms));
      _currencyWord =
          settings.currencySymbol == '€' ? 'euro' : settings.currencySymbol;
    }

    _recalculateTotals(updateState: false);
  }

  @override
  void dispose() {
    _manualNameController.dispose();
    _manualAddressController.dispose();
    _manualCityController.dispose();
    _manualCountryController.dispose();
    _manualEmailController.dispose();
    _manualPhoneController.dispose();
    _manualTaxNumberController.dispose();
    super.dispose();
  }

  void _recalculateTotals({bool updateState = true}) {
    _subtotal = _items.fold(
      0,
      (sum, item) => sum + item.lineTotal,
    );
    _vatAmount = _subtotal * (_vatRate / 100);
    _total = _subtotal + _vatAmount;
    _totalInWords = numberToWords(_total, currency: _currencyWord);

    if (updateState) {
      setState(() {});
    }
  }

  void _updateDueDateFromTerms(int days) {
    _dueDate = _invoiceDate.add(Duration(days: days));
    _paymentTerms = _paymentTermsValue(days);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Typed providers
    final clients = context.watch<ClientService>().clients;
    final companies = context.watch<CompanyService>().companies;
    final settings = context.watch<SettingsService>().settings;
    final currency = settings.currencySymbol;

    final paymentTermsOptions = {
      _paymentTermsValue(0),
      _paymentTermsValue(7),
      _paymentTermsValue(14),
      _paymentTermsValue(30),
      _paymentTerms,
    }.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingInvoice != null ? context.l10n.tr('editInvoice') : context.l10n.tr('newInvoice'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCompanyId,
                decoration: InputDecoration(labelText: context.l10n.tr('selectCompany')),
                items: companies
                    .map(
                      (company) => DropdownMenuItem<String>(
                        value: company.id,
                        child: Text(company.name),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCompanyId = val),
                validator: (val) => val == null ? context.l10n.tr('chooseCompany') : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _useManualClient ? null : _selectedClientId,
                decoration: InputDecoration(labelText: context.l10n.tr('selectClient')),
                items: clients
                    .map(
                      (c) => DropdownMenuItem<String>(
                        value: c.id,
                        child: Text(c.name),
                      ),
                    )
                    .toList(),
                onChanged: _useManualClient
                    ? null
                    : (val) => setState(() => _selectedClientId = val),
                validator: (val) =>
                    _useManualClient ? null : val == null ? context.l10n.tr('chooseClient') : null,
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.tr('enterClientManually')),
                value: _useManualClient,
                onChanged: (value) {
                  setState(() {
                    _useManualClient = value;
                    if (value) {
                      _selectedClientId = null;
                    }
                  });
                },
              ),
              if (_useManualClient) ...[
                TextFormField(
                  controller: _manualNameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.tr('clientName'),
                  ),
                  validator: (val) {
                    if (!_useManualClient) return null;
                    if (val == null || val.trim().isEmpty) {
                      return context.l10n.tr('enterClientName');
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _manualAddressController,
                  decoration: InputDecoration(
                    labelText: context.l10n.tr('address'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _manualCityController,
                        decoration: InputDecoration(
                          labelText: context.l10n.tr('city'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _manualCountryController,
                        decoration: InputDecoration(
                          labelText: context.l10n.tr('country'),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _manualEmailController,
                        decoration: InputDecoration(
                          labelText: context.l10n.tr('email'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _manualPhoneController,
                        decoration: InputDecoration(
                          labelText: context.l10n.tr('phone'),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _manualTaxNumberController,
                  decoration: InputDecoration(
                    labelText: context.l10n.tr('taxNumber'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.l10n.tr('invoiceDate')),
                      subtitle: Text(
                        DateFormat.yMMMd().format(_invoiceDate),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: _invoiceDate,
                        );
                        if (picked != null) {
                          setState(() {
                            _invoiceDate = picked;
                            _dueDate = _invoiceDate.add(
                              Duration(
                                days: _extractDaysFromTerms(),
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.l10n.tr('dueDate')),
                      subtitle: Text(
                        DateFormat.yMMMd().format(_dueDate),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: _dueDate,
                        );
                        if (picked != null) {
                          setState(() {
                            _dueDate = picked;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _paymentTerms,
                decoration: InputDecoration(labelText: context.l10n.tr('paymentTerms')),
                items: paymentTermsOptions
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(_localizedPaymentTerms(context, option)),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    _paymentTerms = val;
                    _updateDueDateFromTerms(_extractDaysFromTerms());
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: context.l10n.tr('vatRate'),
                      ),
                      initialValue: _vatRate.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        _vatRate = double.tryParse(val) ?? 0;
                        _recalculateTotals();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<InvoiceStatus>(
                      value: _status,
                      decoration: InputDecoration(
                        labelText: context.l10n.tr('status'),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: InvoiceStatus.paid,
                          child: Text(context.l10n.tr('paid')),
                        ),
                        DropdownMenuItem(
                          value: InvoiceStatus.unpaid,
                          child: Text(context.l10n.tr('unpaid')),
                        ),
                        DropdownMenuItem(
                          value: InvoiceStatus.partial,
                          child: Text(context.l10n.tr('partial')),
                        ),
                      ],
                      onChanged: (val) => setState(
                            () => _status = val ?? InvoiceStatus.unpaid,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.tr('items'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _items.add(
                          InvoiceItem(
                            description: '${context.l10n.tr('item')} ${_items.length + 1}',
                            quantity: 1,
                            unit: 'pcs',
                            unitPrice: 0,
                            discount: 0,
                            lineTotal: 0,
                          ),
                        );
                      });
                      _recalculateTotals();
                    },
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n.tr('addItem')),
                  )
                ],
              ),
              const Divider(),
              ..._items.asMap().entries.map(
                    (entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${context.l10n.tr('item')} ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _items.removeAt(index);
                                  });
                                  _recalculateTotals();
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                              )
                            ],
                          ),
                          TextFormField(
                            initialValue: item.description,
                            decoration: InputDecoration(
                              labelText: context.l10n.tr('description'),
                            ),
                            onChanged: (val) {
                              _items[index] =
                                  item.copyWith(description: val);
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue:
                                  item.quantity.toString(),
                                  decoration:
                                  InputDecoration(
                                    labelText: context.l10n.tr('quantity'),
                                  ),
                                  keyboardType:
                                  TextInputType.number,
                                  onChanged: (val) {
                                    final qty =
                                        double.tryParse(val) ?? 0;
                                    final lineTotal =
                                    InvoiceItem.calculateLineTotal(
                                      quantity: qty,
                                      unitPrice: item.unitPrice,
                                      discount: item.discount,
                                    );
                                    _items[index] = item.copyWith(
                                      quantity: qty,
                                      lineTotal: lineTotal,
                                    );
                                    _recalculateTotals();
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  initialValue: item.unit,
                                  decoration:
                                  InputDecoration(
                                    labelText: context.l10n.tr('unit'),
                                  ),
                                  onChanged: (val) {
                                    _items[index] =
                                        item.copyWith(unit: val);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue:
                                  item.unitPrice.toString(),
                                  decoration:
                                  InputDecoration(
                                    labelText: context.l10n.tr('unitPrice'),
                                  ),
                                  keyboardType:
                                  TextInputType.number,
                                  onChanged: (val) {
                                    final price =
                                        double.tryParse(val) ?? 0;
                                    final lineTotal =
                                    InvoiceItem.calculateLineTotal(
                                      quantity: item.quantity,
                                      unitPrice: price,
                                      discount: item.discount,
                                    );
                                    _items[index] = item.copyWith(
                                      unitPrice: price,
                                      lineTotal: lineTotal,
                                    );
                                    _recalculateTotals();
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  initialValue:
                                  item.discount.toString(),
                                  decoration:
                                  InputDecoration(
                                    labelText: context.l10n.tr('discount'),
                                  ),
                                  keyboardType:
                                  TextInputType.number,
                                  onChanged: (val) {
                                    final discount =
                                        double.tryParse(val) ?? 0;
                                    final lineTotal =
                                    InvoiceItem.calculateLineTotal(
                                      quantity: item.quantity,
                                      unitPrice: item.unitPrice,
                                      discount: discount,
                                    );
                                    _items[index] = item.copyWith(
                                      discount: discount,
                                      lineTotal: lineTotal,
                                    );
                                    _recalculateTotals();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${context.l10n.tr('lineTotal')}: $currency ${item.lineTotal.toStringAsFixed(2)}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: Text(context.l10n.tr('subtotal')),
                trailing: Text(
                  '$currency ${_subtotal.toStringAsFixed(2)}',
                ),
              ),
              ListTile(
                title:
                Text('VAT (${_vatRate.toStringAsFixed(1)}%)'),
                trailing: Text(
                  '$currency ${_vatAmount.toStringAsFixed(2)}',
                ),
              ),
              ListTile(
                title: const Text(
                  context.l10n.tr('total'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '$currency ${_total.toStringAsFixed(2)}',
                ),
              ),
              ListTile(
                title: Text(context.l10n.tr('totalInWords')),
                subtitle: Text(_totalInWords),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() != true) {
                    return;
                  }

                  if (_items.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                        Text(context.l10n.tr('addAtLeastOneItem')),
                      ),
                    );
                    return;
                  }

                  final clientSnapshot = _useManualClient
                      ? (
                          id: '',
                          name: _manualNameController.text.trim(),
                          address: _manualAddressController.text.trim(),
                          city: _manualCityController.text.trim(),
                          country: _manualCountryController.text.trim(),
                          email: _manualEmailController.text.trim(),
                          phone: _manualPhoneController.text.trim(),
                          taxNumber: _manualTaxNumberController.text.trim(),
                        )
                      : (() {
                          final selectedClient = clients
                              .firstWhere((c) => c.id == _selectedClientId);
                          return (
                            id: selectedClient.id,
                            name: selectedClient.name,
                            address: selectedClient.address,
                            city: selectedClient.city,
                            country: selectedClient.country,
                            email: selectedClient.email,
                            phone: selectedClient.phone,
                            taxNumber: selectedClient.taxNumber,
                          );
                        })();

                  CompanyProfile? selectedCompany;
                  for (final company in companies) {
                    if (company.id == _selectedCompanyId) {
                      selectedCompany = company;
                      break;
                    }
                  }
                  final companySnapshot = selectedCompany ??
                      CompanyProfile(
                        id: '',
                        name: '',
                        address: '',
                        city: '',
                        country: '',
                        phone: '',
                        email: '',
                        taxNumber: '',
                        bankName: '',
                        iban: '',
                        website: '',
                        logoPath: '',
                      );

                  final settingsService = context.read<SettingsService>();
                  final invoiceService = context.read<InvoiceService>();

                  if (widget.existingInvoice != null) {
                    final updatedInvoice = widget.existingInvoice!.copyWith(
                      companyId: companySnapshot.id,
                      companyName: companySnapshot.name,
                      companyAddress: companySnapshot.address,
                      companyCity: companySnapshot.city,
                      companyCountry: companySnapshot.country,
                      companyPhone: companySnapshot.phone,
                      companyEmail: companySnapshot.email,
                      companyTaxNumber: companySnapshot.taxNumber,
                      companyBankName: companySnapshot.bankName,
                      companyIban: companySnapshot.iban,
                      companyWebsite: companySnapshot.website,
                      companyLogoPath: companySnapshot.logoPath,
                      clientId: clientSnapshot.id,
                      clientName: clientSnapshot.name,
                      clientAddress: clientSnapshot.address,
                      clientCity: clientSnapshot.city,
                      clientCountry: clientSnapshot.country,
                      clientEmail: clientSnapshot.email,
                      clientPhone: clientSnapshot.phone,
                      clientTaxNumber: clientSnapshot.taxNumber,
                      date: _invoiceDate,
                      dueDate: _dueDate,
                      paymentTerms: _paymentTerms,
                      items: _items,
                      subtotal: _subtotal,
                      vatRate: _vatRate,
                      vatAmount: _vatAmount,
                      total: _total,
                      totalInWords: _totalInWords,
                      currency: currency,
                      status: _status,
                    );

                    await invoiceService.updateInvoice(updatedInvoice);
                  } else {
                    final invoiceNumber =
                        await settingsService.getNextInvoiceNumber();

                    final invoice = Invoice(
                      id: const Uuid().v4(),
                      invoiceNumber: invoiceNumber,
                      companyId: companySnapshot.id,
                      companyName: companySnapshot.name,
                      companyAddress: companySnapshot.address,
                      companyCity: companySnapshot.city,
                      companyCountry: companySnapshot.country,
                      companyPhone: companySnapshot.phone,
                      companyEmail: companySnapshot.email,
                      companyTaxNumber: companySnapshot.taxNumber,
                      companyBankName: companySnapshot.bankName,
                      companyIban: companySnapshot.iban,
                      companyWebsite: companySnapshot.website,
                      companyLogoPath: companySnapshot.logoPath,
                      clientId: clientSnapshot.id,
                      clientName: clientSnapshot.name,
                      clientAddress: clientSnapshot.address,
                      clientCity: clientSnapshot.city,
                      clientCountry: clientSnapshot.country,
                      clientEmail: clientSnapshot.email,
                      clientPhone: clientSnapshot.phone,
                      clientTaxNumber: clientSnapshot.taxNumber,
                      date: _invoiceDate,
                      dueDate: _dueDate,
                      paymentTerms: _paymentTerms,
                      items: _items,
                      subtotal: _subtotal,
                      vatRate: _vatRate,
                      vatAmount: _vatAmount,
                      total: _total,
                      totalInWords: _totalInWords,
                      currency: currency,
                      status: _status,
                    );

                    await invoiceService.addInvoice(invoice);
                  }

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  widget.existingInvoice != null
                      ? context.l10n.tr('updateInvoice')
                      : context.l10n.tr('saveInvoice'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  String _paymentTermsValue(int days) {
    return days == 0 ? 'due_on_receipt' : '$days days';
  }

  String _localizedPaymentTerms(BuildContext context, String terms) {
    if (terms == 'due_on_receipt' || terms.toLowerCase() == 'due on receipt') {
      return context.l10n.tr('dueOnReceipt');
    }
    final digits = RegExp(r'\d+').firstMatch(terms);
    if (digits != null) {
      return '${digits.group(0)} ${context.l10n.tr('days')}';
    }
    return terms;
  }

  int _extractDaysFromTerms() {
    final digits = RegExp(r'\d+').firstMatch(_paymentTerms);
    return digits != null ? int.parse(digits.group(0)!) : 0;
  }
}
