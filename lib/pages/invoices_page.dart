import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/invoice.dart';
import '../services/invoice_service.dart';
import '../widgets/status_chip.dart';
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
    final invoices = context.watch<InvoiceService>().invoices;

    final filtered = invoices.where((inv) {
      final query = _search.toLowerCase();
      final matchesSearch = inv.invoiceNumber.toLowerCase().contains(query) ||
          inv.clientName.toLowerCase().contains(query);
      final matchesStatus = _filterStatus == null || inv.status == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: context.l10n.tr('searchInvoices'),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () => setState(() => _search = ''),
                            icon: const Icon(Icons.close),
                          ),
                  ),
                  onChanged: (val) => setState(() => _search = val),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SegmentedButton<InvoiceStatus?>(
                          showSelectedIcon: false,
                          segments: [
                            ButtonSegment<InvoiceStatus?>(
                              value: null,
                              label: Text(context.l10n.tr('all')),
                            ),
                            ButtonSegment<InvoiceStatus?>(
                              value: InvoiceStatus.paid,
                              label: Text(context.l10n.tr('paid')),
                            ),
                            ButtonSegment<InvoiceStatus?>(
                              value: InvoiceStatus.partial,
                              label: Text(context.l10n.tr('partial')),
                            ),
                            ButtonSegment<InvoiceStatus?>(
                              value: InvoiceStatus.unpaid,
                              label: Text(context.l10n.tr('unpaid')),
                            ),
                          ],
                          selected: {_filterStatus},
                          onSelectionChanged: (selection) {
                            setState(() => _filterStatus = selection.firstOrNull);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const InvoiceFormPage()),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: Text(context.l10n.tr('new')),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text(context.l10n.tr('noInvoicesYet')))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final invoice = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: const Icon(Icons.receipt_long),
                          ),
                          title: Text(invoice.invoiceNumber),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(invoice.clientName),
                                Text(invoice.date.toLocal().toString().split(' ').first),
                                const SizedBox(height: 6),
                                StatusChip(status: invoice.status),
                              ],
                            ),
                          ),
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
                                        title: Text(context.l10n.tr('deleteInvoice')),
                                        content: Text(context.l10n.tr('deleteInvoiceConfirm')),
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

                                    if (confirmed == true && context.mounted) {
                                      await context.read<InvoiceService>().deleteInvoice(invoice.id);
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text(context.l10n.tr('edit')),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text(context.l10n.tr('delete')),
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
                                builder: (_) => InvoiceDetailPage(invoiceId: invoice.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
