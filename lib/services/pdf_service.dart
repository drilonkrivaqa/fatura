import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/app_settings.dart';
import '../models/client.dart';
import '../models/company_profile.dart';
import '../models/invoice.dart';
import '../utils/number_to_words.dart';

class PdfService {
  Future<Uint8List> buildInvoice(
    Invoice invoice,
    CompanyProfile? company,
    Client? client,
    AppSettings settings,
  ) async {
    final baseFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: baseFont,
        bold: boldFont,
      ),
    );    final currency = settings.currencySymbol;
    final billToName = invoice.clientName.isNotEmpty
        ? invoice.clientName
        : client?.name ?? '';
    final billToAddress = invoice.clientAddress.isNotEmpty
        ? invoice.clientAddress
        : client?.address ?? '';
    final billToCity = invoice.clientCity.isNotEmpty
        ? invoice.clientCity
        : client?.city ?? '';
    final billToCountry = invoice.clientCountry.isNotEmpty
        ? invoice.clientCountry
        : client?.country ?? '';
    final billToCityCountry = [billToCity, billToCountry]
        .where((part) => part.isNotEmpty)
        .join(', ');
    final billToEmail = invoice.clientEmail.isNotEmpty
        ? invoice.clientEmail
        : client?.email ?? '';
    final billToPhone = invoice.clientPhone.isNotEmpty
        ? invoice.clientPhone
        : client?.phone ?? '';
    final billToTaxNumber = invoice.clientTaxNumber.isNotEmpty
        ? invoice.clientTaxNumber
        : client?.taxNumber ?? '';

    final formatCurrency = NumberFormat.currency(
      symbol: currency,
      decimalDigits: 2,
    );

    final logo = company?.logoPath.isNotEmpty == true
        ? await pw.MemoryImage(await _readLogo(company!.logoPath))
        : null;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('INVOICE',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 12),
                  pw.Text('Invoice #: ${invoice.invoiceNumber}'),
                  pw.Text('Date: ${DateFormat.yMMMd().format(invoice.date)}'),
                  pw.Text('Due: ${DateFormat.yMMMd().format(invoice.dueDate)}'),
                  pw.Text('Payment terms: ${invoice.paymentTerms}'),
                ],
              ),
              if (logo != null)
                pw.Container(width: 120, height: 120, child: pw.Image(logo, fit: pw.BoxFit.contain)),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Divider(),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(company?.name ?? 'Your Company',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    pw.Text(company?.address ?? ''),
                    pw.Text('${company?.city ?? ''}, ${company?.country ?? ''}'),
                    pw.Text('Phone: ${company?.phone ?? ''}'),
                    pw.Text('Email: ${company?.email ?? ''}'),
                    pw.Text('Tax: ${company?.taxNumber ?? ''}'),
                    pw.Text('Bank: ${company?.bankName ?? ''}'),
                    pw.Text('IBAN: ${company?.iban ?? ''}'),
                    if ((company?.website ?? '').isNotEmpty) pw.Text('Website: ${company?.website ?? ''}'),
                  ],
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Bill To',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                    pw.Text(billToName),
                    pw.Text(billToAddress),
                    pw.Text(billToCityCountry),
                    pw.Text('Email: $billToEmail'),
                    pw.Text('Phone: $billToPhone'),
                    if (billToTaxNumber.isNotEmpty) pw.Text('Tax: $billToTaxNumber'),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['#', 'Description', 'Qty', 'Unit', 'Unit price', 'Discount', 'Line total'],
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
            cellAlignment: pw.Alignment.centerLeft,
            data: List<List<String>>.generate(invoice.items.length, (index) {
              final item = invoice.items[index];
              return [
                '${index + 1}',
                item.description,
                item.quantity.toStringAsFixed(2),
                item.unit,
                formatCurrency.format(item.unitPrice),
                '${item.discount.toStringAsFixed(1)} %',
                formatCurrency.format(item.lineTotal),
              ];
            }),
            cellAlignments: {
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight,
            },
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Payment terms: ${invoice.paymentTerms}'),
                    pw.SizedBox(height: 8),
                    pw.Text('Total in words:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(numberToWords(
                        invoice.total,
                        currency: invoice.currency == '€' ? 'euro' : invoice.currency)),
                    pw.SizedBox(height: 12),
                    pw.Text('Thank you for your business!',
                        style: pw.TextStyle(color: PdfColors.blueGrey700)),
                  ],
                ),
              ),
              pw.SizedBox(width: 20),
              pw.Container(
                width: 200,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    _totalRow('Subtotal', formatCurrency.format(invoice.subtotal)),
                    _totalRow('VAT (${invoice.vatRate.toStringAsFixed(1)}%)',
                        formatCurrency.format(invoice.vatAmount)),
                    pw.Divider(),
                    _totalRow('TOTAL', formatCurrency.format(invoice.total), bold: true),
                  ],
                ),
              )
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Text('Status: ${invoice.status.name.toUpperCase()}'),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _totalRow(String label, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
          pw.Text(value, style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
        ],
      ),
    );
  }

  Future<Uint8List> _readLogo(String path) async {
    if (path.startsWith('data:')) {
      final encoded = path.split(',').last;
      return Uint8List.fromList(base64Decode(encoded));
    }
    final file = File(path);
    return file.readAsBytes();
  }
}
