import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../services/client_service.dart';
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

class _InvoiceFormPageState extends State {
  final _formKey = GlobalKey<FormState>();

  String? _selectedClientId;
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now();
  String _paymentTerms = '';
  double _vatRate = 0;
  InvoiceStatus _status = InvoiceStatus.unpaid;

  List<InvoiceItem> _items = [];
  double _subtotal = 0;
  double _vatAmount = 0;
  double _total = 0;
  String _totalInWords = '';
  String _currencyWord = 'euro';

  @override
  void initState() {
    super.initState();

    final settings = context.read<SettingsService>().settings;

    if (widget.existingInvoice != null) {
      final invoice = widget.existingInvoice!;
      _selectedClientId = invoice.clientId;
      _invoiceDate = invoice.date;
      _dueDate = invoice.dueDate;
      _paymentTerms = invoice.paymentTerms;
      _vatRate = invoice.vatRate;
      _status = invoice.status;
      _items = invoice.items.map((item) => item.copyWith()).toList();
      _currencyWord = invoice.currency == '€' ? 'euro' : invoice.currency;
    } else {
      _vatRate = settings.defaultVatRate;
      _paymentTerms = '${settings.defaultPaymentTerms} days';
      _dueDate =
          _invoiceDate.add(Duration(days: settings.defaultPaymentTerms));
      _currencyWord =
          settings.currencySymbol == '€' ? 'euro' : settings.currencySymbol;
    }

    _recalculateTotals(updateState: false);
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
    _paymentTerms = days == 0 ? 'Due on receipt' : '$days days';
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Typed providers
    final clients = context.watch<ClientService>().clients;
    final settings = context.watch<SettingsService>().settings;
    final currency = settings.currencySymbol;

    final paymentTermsOptions = {
      'Due on receipt',
      '7 days',
      '14 days',
      '30 days',
      _paymentTerms,
    }.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingInvoice != null ? 'Edit Invoice' : 'New Invoice',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedClientId,
                decoration: const InputDecoration(labelText: 'Select client'),
                items: clients
                    .map(
                      (c) => DropdownMenuItem<String>(
                        value: c.id,
                        child: Text(c.name),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedClientId = val),
                validator: (val) => val == null ? 'Choose client' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Invoice date'),
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
                      title: const Text('Due date'),
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
                decoration: const InputDecoration(labelText: 'Payment terms'),
                items: paymentTermsOptions
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
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
                      decoration: const InputDecoration(
                        labelText: 'VAT rate %',
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
                      decoration: const InputDecoration(
                        labelText: 'Status',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: InvoiceStatus.paid,
                          child: Text('Paid'),
                        ),
                        DropdownMenuItem(
                          value: InvoiceStatus.unpaid,
                          child: Text('Unpaid'),
                        ),
                        DropdownMenuItem(
                          value: InvoiceStatus.partial,
                          child: Text('Partial'),
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
                  const Text(
                    'Items',
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
                            description: 'Item ${_items.length + 1}',
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
                    label: const Text('Add item'),
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
                                'Item ${index + 1}',
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
                            decoration: const InputDecoration(
                              labelText: 'Description',
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
                                  const InputDecoration(
                                    labelText: 'Quantity',
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
                                  const InputDecoration(
                                    labelText: 'Unit',
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
                                  const InputDecoration(
                                    labelText: 'Unit price',
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
                                  const InputDecoration(
                                    labelText: 'Discount %',
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
                              'Line total: $currency ${item.lineTotal.toStringAsFixed(2)}',
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
                title: const Text('Subtotal'),
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
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '$currency ${_total.toStringAsFixed(2)}',
                ),
              ),
              ListTile(
                title: const Text('Total in words'),
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
                        Text('Add at least one item'),
                      ),
                    );
                    return;
                  }

                  final selectedClient =
                      clients.firstWhere((c) => c.id == _selectedClientId);

                  final settingsService = context.read<SettingsService>();
                  final invoiceService = context.read<InvoiceService>();

                  if (widget.existingInvoice != null) {
                    final updatedInvoice = widget.existingInvoice!.copyWith(
                      clientId: selectedClient.id,
                      clientName: selectedClient.name,
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
                      clientId: selectedClient.id,
                      clientName: selectedClient.name,
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
                      ? 'Update invoice'
                      : 'Save invoice',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _extractDaysFromTerms() {
    if (_paymentTerms.contains('Due on receipt')) return 0;
    final digits = RegExp(r'\d+').firstMatch(_paymentTerms);
    return digits != null ? int.parse(digits.group(0)!) : 0;
  }
}
