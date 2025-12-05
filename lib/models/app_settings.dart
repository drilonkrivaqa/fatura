import 'package:hive/hive.dart';

class AppSettings {
  final String currencySymbol;
  final double defaultVatRate;
  final int defaultPaymentTerms;
  final int lastInvoiceNumber;

  AppSettings({
    required this.currencySymbol,
    required this.defaultVatRate,
    required this.defaultPaymentTerms,
    required this.lastInvoiceNumber,
  });

  AppSettings copyWith({
    String? currencySymbol,
    double? defaultVatRate,
    int? defaultPaymentTerms,
    int? lastInvoiceNumber,
  }) {
    return AppSettings(
      currencySymbol: currencySymbol ?? this.currencySymbol,
      defaultVatRate: defaultVatRate ?? this.defaultVatRate,
      defaultPaymentTerms: defaultPaymentTerms ?? this.defaultPaymentTerms,
      lastInvoiceNumber: lastInvoiceNumber ?? this.lastInvoiceNumber,
    );
  }
}

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 5;

  @override
  AppSettings read(BinaryReader reader) {
    return AppSettings(
      currencySymbol: reader.readString(),
      defaultVatRate: reader.readDouble(),
      defaultPaymentTerms: reader.readInt(),
      lastInvoiceNumber: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeString(obj.currencySymbol)
      ..writeDouble(obj.defaultVatRate)
      ..writeInt(obj.defaultPaymentTerms)
      ..writeInt(obj.lastInvoiceNumber);
  }
}
