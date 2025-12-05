import 'package:flutter/material.dart';

import '../models/invoice.dart';
import '../models/invoice_item.dart';
import 'hive_service.dart';

class InvoiceService extends ChangeNotifier {
  List<Invoice> _invoices = [];

  List<Invoice> get invoices => _invoices;

  InvoiceService() {
    loadInvoices();
  }

  void loadInvoices() {
    final box = HiveService.invoicesBox();
    _invoices = box.values.toList();
    notifyListeners();
  }

  Future<void> addInvoice(Invoice invoice) async {
    final box = HiveService.invoicesBox();
    await box.put(invoice.id, invoice);
    _invoices = box.values.toList();
    notifyListeners();
  }

  Future<void> updateInvoice(Invoice invoice) async {
    final box = HiveService.invoicesBox();
    await box.put(invoice.id, invoice);
    _invoices = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteInvoice(String id) async {
    final box = HiveService.invoicesBox();
    await box.delete(id);
    _invoices = box.values.toList();
    notifyListeners();
  }

  Invoice? findById(String id) {
    try {
      return _invoices.firstWhere((inv) => inv.id == id);
    } catch (_) {
      return null;
    }
  }

  double calculateSubtotal(List<InvoiceItem> items) {
    return items.fold(0, (sum, item) => sum + item.lineTotal);
  }
}
