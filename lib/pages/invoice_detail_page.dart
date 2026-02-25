import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/company_profile.dart';
import '../models/invoice.dart';
import '../services/client_service.dart';
import '../services/invoice_service.dart';
import '../services/pdf_service.dart';
import '../services/settings_service.dart';
import '../widgets/status_chip.dart';
import 'invoice_form_page.dart';

class InvoiceDetailPage extends StatelessWidget {
  final String invoiceId;

  const InvoiceDetailPage({
    super.key,
    required this.invoiceId,
  });

  @override
  Widget build(BuildContext context) {
    final invoice = context.watch<InvoiceService>().findById(invoiceId);
    final company = CompanyProfile(
      id: invoice?.companyId ?? '',
      name: invoice?.companyName ?? '',
      address: invoice?.companyAddress ?? '',
      city: invoice?.companyCity ?? '',
      country: invoice?.companyCountry ?? '',
      phone: invoice?.companyPhone ?? '',
      email: invoice?.companyEmail ?? '',
      taxNumber: invoice?.companyTaxNumber ?? '',
      bankName: invoice?.companyBankName ?? '',
      iban: invoice?.companyIban ?? '',
      website: invoice?.companyWebsite ?? '',
      logoPath: invoice?.companyLogoPath ?? '',
    );
    final settings = context.watch<SettingsService>().settings;

    if (invoice == null) {
      return Scaffold(
        body: Center(child: Text(context.l10n.tr('invoiceNotFound'))),
      );
    }

    final client = context.read<ClientService>().findById(invoice.clientId);
    final clientName = invoice.clientName.isNotEmpty ? invoice.clientName : client?.name ?? '';
    final clientAddress = invoice.clientAddress.isNotEmpty ? invoice.clientAddress : client?.address ?? '';
    final clientCity = invoice.clientCity.isNotEmpty ? invoice.clientCity : client?.city ?? '';
    final clientCountry = invoice.clientCountry.isNotEmpty ? invoice.clientCountry : client?.country ?? '';
    final clientEmail = invoice.clientEmail.isNotEmpty ? invoice.clientEmail : client?.email ?? '';
    final clientPhone = invoice.clientPhone.isNotEmpty ? invoice.clientPhone : client?.phone ?? '';
    final clientTaxNumber = invoice.clientTaxNumber.isNotEmpty ? invoice.clientTaxNumber : client?.taxNumber ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('${context.l10n.tr('invoice')} ${invoice.invoiceNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              final pdfService = PdfService();
              final data = await pdfService.buildInvoice(invoice, company, client, settings);
              await Printing.sharePdf(bytes: data, filename: '${invoice.invoiceNumber}.pdf');
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InvoiceFormPage(existingInvoice: invoice)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
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

              if (confirmed == true) {
                await context.read<InvoiceService>().deleteInvoice(invoice.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(clientName, style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      [
                        clientAddress,
                        [clientCity, clientCountry].where((part) => part.isNotEmpty).join(', '),
                        clientEmail,
                        clientPhone,
                        if (clientTaxNumber.isNotEmpty) '${context.l10n.tr('taxLabel')}: $clientTaxNumber',
                      ].where((line) => line.isNotEmpty).join('\n'),
                    ),
                  ],
                ),
                StatusChip(status: invoice.status),
              ],
            ),
            const SizedBox(height: 12),
            Text('${context.l10n.tr('invoiceNumber')}: ${invoice.invoiceNumber}'),
            Text('${context.l10n.tr('date')}: ${invoice.date.toLocal().toString().split(' ').first}'),
            Text('${context.l10n.tr('due')}: ${invoice.dueDate.toLocal().toString().split(' ').first}'),
            Text('${context.l10n.tr('paymentTerms')}: ${_localizedPaymentTerms(context, invoice.paymentTerms)}'),
            const SizedBox(height: 12),
            Text(context.l10n.tr('items'), style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ...invoice.items.map(
              (item) => ListTile(
                title: Text(item.description),
                subtitle: Text(
                  '${item.quantity.toStringAsFixed(2)} ${item.unit} x ${item.unitPrice.toStringAsFixed(2)} '
                  '(${context.l10n.tr('discountLabel')} ${item.discount.toStringAsFixed(1)}%)',
                ),
                trailing: Text(item.lineTotal.toStringAsFixed(2)),
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(context.l10n.tr('subtotal')),
              trailing: Text(invoice.subtotal.toStringAsFixed(2)),
            ),
            ListTile(
              title: Text('VAT (${invoice.vatRate.toStringAsFixed(1)}%)'),
              trailing: Text(invoice.vatAmount.toStringAsFixed(2)),
            ),
            ListTile(
              title: Text(
                context.l10n.tr('total'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(invoice.total.toStringAsFixed(2)),
            ),
            ListTile(
              title: Text(context.l10n.tr('totalInWords')),
              subtitle: Text(invoice.totalInWords),
            ),
          ],
        ),
      ),
    );
  }
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
