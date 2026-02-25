import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/invoice.dart';
import '../services/invoice_service.dart';
import 'invoice_detail_page.dart';
import 'invoice_form_page.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  String _search = '';
  InvoiceStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final invoices = context.watch<InvoiceService>().invoices;

    final filtered = invoices.where((inv) {
      final matchesSearch = inv.invoiceNumber.toLowerCase().contains(_search.toLowerCase()) ||
          inv.clientName.toLowerCase().contains(_search.toLowerCase());
      final matchesStatus = _filterStatus == null || inv.status == _filterStatus;
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
                    decoration: InputDecoration(
                      hintText: l10n.tr('searchInvoices'),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (val) => setState(() => _search = val),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<InvoiceStatus?>(
                  value: _filterStatus,
                  hint: Text(l10n.tr('status')),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.tr('all'))),
                    DropdownMenuItem(value: InvoiceStatus.paid, child: Text(l10n.tr('paid'))),
                    DropdownMenuItem(value: InvoiceStatus.unpaid, child: Text(l10n.tr('unpaid'))),
                    DropdownMenuItem(value: InvoiceStatus.partial, child: Text(l10n.tr('partial'))),
                  ],
                  onChanged: (value) => setState(() => _filterStatus = value),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InvoiceFormPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l10n.tr('new')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(l10n.tr('noInvoices')))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final invoice = filtered[index];
                        return ListTile(
                          title: Text(invoice.invoiceNumber),
                          subtitle: Text('${invoice.clientName}\n${invoice.date.toLocal().toString().split(' ').first}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(invoice.total.toStringAsFixed(2)),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => InvoiceFormPage(existingInvoice: invoice),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(l10n.tr('delete')),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text(l10n.tr('cancel')),
                                          ),
                                          FilledButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: Text(l10n.tr('delete')),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmed == true) {
                                      await context.read<InvoiceService>().deleteInvoice(invoice.id);
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(value: 'edit', child: Text(l10n.tr('editInvoice'))),
                                  PopupMenuItem(value: 'delete', child: Text(l10n.tr('delete'))),
                                ],
                                icon: const Icon(Icons.more_vert),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => InvoiceDetailPage(invoiceId: invoice.id)),
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
