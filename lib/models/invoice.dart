import 'package:hive/hive.dart';

import 'invoice_item.dart';

enum InvoiceStatus { paid, unpaid, partial }

class Invoice {
  final String id;
  final String invoiceNumber;
  final String clientId;
  final String clientName;
  final DateTime date;
  final DateTime dueDate;
  final String paymentTerms;
  final List<InvoiceItem> items;
  final double subtotal;
  final double vatRate;
  final double vatAmount;
  final double total;
  final String totalInWords;
  final String currency;
  final InvoiceStatus status;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.clientId,
    required this.clientName,
    required this.date,
    required this.dueDate,
    required this.paymentTerms,
    required this.items,
    required this.subtotal,
    required this.vatRate,
    required this.vatAmount,
    required this.total,
    required this.totalInWords,
    required this.currency,
    required this.status,
  });

  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    String? clientId,
    String? clientName,
    DateTime? date,
    DateTime? dueDate,
    String? paymentTerms,
    List<InvoiceItem>? items,
    double? subtotal,
    double? vatRate,
    double? vatAmount,
    double? total,
    String? totalInWords,
    String? currency,
    InvoiceStatus? status,
  }) {
    return Invoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      vatRate: vatRate ?? this.vatRate,
      vatAmount: vatAmount ?? this.vatAmount,
      total: total ?? this.total,
      totalInWords: totalInWords ?? this.totalInWords,
      currency: currency ?? this.currency,
      status: status ?? this.status,
    );
  }
}

class InvoiceStatusAdapter extends TypeAdapter<InvoiceStatus> {
  @override
  final int typeId = 3;

  @override
  InvoiceStatus read(BinaryReader reader) {
    final value = reader.readInt();
    return InvoiceStatus.values[value];
  }

  @override
  void write(BinaryWriter writer, InvoiceStatus obj) {
    writer.writeInt(obj.index);
  }
}

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 4;

  @override
  Invoice read(BinaryReader reader) {
    final id = reader.readString();
    final invoiceNumber = reader.readString();
    final clientId = reader.readString();
    final clientName = reader.readString();
    final date = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final dueDate = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final paymentTerms = reader.readString();
    final itemCount = reader.readInt();
    final items = <InvoiceItem>[];
    for (int i = 0; i < itemCount; i++) {
      items.add(reader.read() as InvoiceItem);
    }
    final subtotal = reader.readDouble();
    final vatRate = reader.readDouble();
    final vatAmount = reader.readDouble();
    final total = reader.readDouble();
    final totalInWords = reader.readString();
    final currency = reader.readString();
    final status = reader.read() as InvoiceStatus;
    return Invoice(
      id: id,
      invoiceNumber: invoiceNumber,
      clientId: clientId,
      clientName: clientName,
      date: date,
      dueDate: dueDate,
      paymentTerms: paymentTerms,
      items: items,
      subtotal: subtotal,
      vatRate: vatRate,
      vatAmount: vatAmount,
      total: total,
      totalInWords: totalInWords,
      currency: currency,
      status: status,
    );
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.invoiceNumber)
      ..writeString(obj.clientId)
      ..writeString(obj.clientName)
      ..writeInt(obj.date.millisecondsSinceEpoch)
      ..writeInt(obj.dueDate.millisecondsSinceEpoch)
      ..writeString(obj.paymentTerms)
      ..writeInt(obj.items.length);
    for (final item in obj.items) {
      writer.write(item);
    }
    writer
      ..writeDouble(obj.subtotal)
      ..writeDouble(obj.vatRate)
      ..writeDouble(obj.vatAmount)
      ..writeDouble(obj.total)
      ..writeString(obj.totalInWords)
      ..writeString(obj.currency)
      ..write(obj.status);
  }
}
