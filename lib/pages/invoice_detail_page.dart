import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../models/invoice.dart';
import '../services/client_service.dart';
import '../services/company_service.dart';
import '../services/invoice_service.dart';
import '../services/pdf_service.dart';
import '../services/settings_service.dart';
import '../widgets/status_chip.dart';

class InvoiceDetailPage extends StatelessWidget {
  final String invoiceId;

  const InvoiceDetailPage({
    super.key,
    required this.invoiceId,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Typed providers
    final invoice =
    context.watch<InvoiceService>().findById(invoiceId);
    final company = context.watch<CompanyService>().profile;
    final settings = context.watch<SettingsService>().settings;

    if (invoice == null) {
      return const Scaffold(
        body: Center(child: Text('Invoice not found')),
      );
    }

    // ✅ Typed provider
    final client =
    context.read<ClientService>().findById(invoice.clientId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice ${invoice.invoiceNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              final pdfService = PdfService();
              final data = await pdfService.buildInvoice(
                invoice,
                company,
                client,
                settings,
              );
              await Printing.sharePdf(
                bytes: data,
                filename: '${invoice.invoiceNumber}.pdf',
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.clientName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                    if (client != null)
                      Text(
                        '${client.address}\n'
                            '${client.city}, ${client.country}\n'
                            '${client.email}',
                      ),
                  ],
                ),
                StatusChip(status: invoice.status),
              ],
            ),
            const SizedBox(height: 12),
            Text('Invoice #: ${invoice.invoiceNumber}'),
            Text(
              'Date: ${invoice.date.toLocal().toString().split(' ').first}',
            ),
            Text(
              'Due: ${invoice.dueDate.toLocal().toString().split(' ').first}',
            ),
            Text('Payment terms: ${invoice.paymentTerms}'),
            const SizedBox(height: 12),
            const Text(
              'Items',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...invoice.items.map(
                  (item) => ListTile(
                title: Text(item.description),
                subtitle: Text(
                  '${item.quantity.toStringAsFixed(2)} '
                      '${item.unit} x '
                      '${item.unitPrice.toStringAsFixed(2)} '
                      '(discount ${item.discount.toStringAsFixed(1)}%)',
                ),
                trailing:
                Text(item.lineTotal.toStringAsFixed(2)),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Subtotal'),
              trailing:
              Text(invoice.subtotal.toStringAsFixed(2)),
            ),
            ListTile(
              title: Text(
                'VAT (${invoice.vatRate.toStringAsFixed(1)}%)',
              ),
              trailing:
              Text(invoice.vatAmount.toStringAsFixed(2)),
            ),
            ListTile(
              title: const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(invoice.total.toStringAsFixed(2)),
            ),
            ListTile(
              title: const Text('Total in words'),
              subtitle: Text(invoice.totalInWords),
            ),
          ],
        ),
      ),
    );
  }
}
