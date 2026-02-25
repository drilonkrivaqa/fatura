import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n.dart';
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
                    decoration: InputDecoration(
                      hintText: context.t('Search invoices'),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) => setState(() => _search = val),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<InvoiceStatus?>(
                  value: _filterStatus,
                  hint: Text(context.t('Status')),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(context.t('All')),
                    ),
                    DropdownMenuItem(
                      value: InvoiceStatus.paid,
                      child: Text(context.t('Paid')),
                    ),
                    DropdownMenuItem(
                      value: InvoiceStatus.unpaid,
                      child: Text(context.t('Unpaid')),
                    ),
                    DropdownMenuItem(
                      value: InvoiceStatus.partial,
                      child: Text(context.t('Partial')),
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
                  label: Text(context.t('New')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(context.t('No invoices found.')))
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          invoice.total.toStringAsFixed(2),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => InvoiceFormPage(
                                    existingInvoice: invoice,
                                  ),
                                ),
                              );
                            } else if (value == 'delete') {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(context.t('Delete invoice')),
                                    content: Text(
                                      context.t('Are you sure you want to delete this invoice? This action cannot be undone.'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text(context.t('Cancel')),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text(context.t('Delete')),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmed == true) {
                                await context
                                    .read<InvoiceService>()
                                    .deleteInvoice(invoice.id);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(context.t('Edit')),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
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
