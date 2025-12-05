import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/invoice.dart';
import '../services/invoice_service.dart';
import 'invoice_detail_page.dart';
import 'invoice_form_page.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State {
  String _search = '';
  InvoiceStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    // ✅ Typed provider
    final invoices = context.watch<InvoiceService>().invoices;

    final filtered = invoices.where((inv) {
      final matchesSearch =
          inv.invoiceNumber.toLowerCase().contains(_search.toLowerCase()) ||
              inv.clientName.toLowerCase().contains(_search.toLowerCase());
      final matchesStatus =
          _filterStatus == null || inv.status == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by invoice # or client',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) => setState(() => _search = val),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<InvoiceStatus?>(
                  value: _filterStatus,
                  hint: const Text('Status'),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All'),
                    ),
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
                  onChanged: (value) =>
                      setState(() => _filterStatus = value),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InvoiceFormPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No invoices yet.'))
                  : ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final invoice = filtered[index];
                  return ListTile(
                    leading: Icon(
                      invoice.status == InvoiceStatus.paid
                          ? Icons.check_circle
                          : invoice.status ==
                          InvoiceStatus.partial
                          ? Icons.timelapse
                          : Icons.pending_actions,
                      color: invoice.status == InvoiceStatus.paid
                          ? Colors.green
                          : invoice.status ==
                          InvoiceStatus.partial
                          ? Colors.orange
                          : Colors.red,
                    ),
                    title: Text(invoice.invoiceNumber),
                    subtitle: Text(
                      '${invoice.clientName}\n${invoice.date.toLocal().toString().split(' ').first}',
                    ),
                    isThreeLine: true,
                    trailing: Text(
                      invoice.total.toStringAsFixed(2),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoiceDetailPage(
                            invoiceId: invoice.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
