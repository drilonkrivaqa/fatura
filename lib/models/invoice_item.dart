import 'package:hive/hive.dart';

class InvoiceItem {
  final String description;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double discount; // percentage discount
  final double lineTotal;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.discount,
    required this.lineTotal,
  });

  InvoiceItem copyWith({
    String? description,
    double? quantity,
    String? unit,
    double? unitPrice,
    double? discount,
    double? lineTotal,
  }) {
    return InvoiceItem(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }

  static double calculateLineTotal({
    required double quantity,
    required double unitPrice,
    required double discount,
  }) {
    final gross = quantity * unitPrice;
    final discountAmount = gross * (discount / 100);
    return gross - discountAmount;
  }
}

class InvoiceItemAdapter extends TypeAdapter<InvoiceItem> {
  @override
  final int typeId = 2;

  @override
  InvoiceItem read(BinaryReader reader) {
    return InvoiceItem(
      description: reader.readString(),
      quantity: reader.readDouble(),
      unit: reader.readString(),
      unitPrice: reader.readDouble(),
      discount: reader.readDouble(),
      lineTotal: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceItem obj) {
    writer
      ..writeString(obj.description)
      ..writeDouble(obj.quantity)
      ..writeString(obj.unit)
      ..writeDouble(obj.unitPrice)
      ..writeDouble(obj.discount)
      ..writeDouble(obj.lineTotal);
  }
}
