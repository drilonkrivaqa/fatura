import 'package:hive/hive.dart';

class AppSettings {
  final String currencySymbol;
  final double defaultVatRate;
  final int defaultPaymentTerms;
  final int lastInvoiceNumber;
  final String themeMode; // allowed values: 'system', 'light', 'dark'

  AppSettings({
    required this.currencySymbol,
    required this.defaultVatRate,
    required this.defaultPaymentTerms,
    required this.lastInvoiceNumber,
    required this.themeMode,
  });

  AppSettings copyWith({
    String? currencySymbol,
    double? defaultVatRate,
    int? defaultPaymentTerms,
    int? lastInvoiceNumber,
    String? themeMode,
  }) {
    return AppSettings(
      currencySymbol: currencySymbol ?? this.currencySymbol,
      defaultVatRate: defaultVatRate ?? this.defaultVatRate,
      defaultPaymentTerms: defaultPaymentTerms ?? this.defaultPaymentTerms,
      lastInvoiceNumber: lastInvoiceNumber ?? this.lastInvoiceNumber,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 5;

  @override
  AppSettings read(BinaryReader reader) {
    final currencySymbol = reader.readString();
    final defaultVatRate = reader.readDouble();
    final defaultPaymentTerms = reader.readInt();
    final lastInvoiceNumber = reader.readInt();
    final themeMode = reader.availableBytes > 0 ? reader.readString() : 'system';

    return AppSettings(
      currencySymbol: currencySymbol,
      defaultVatRate: defaultVatRate,
      defaultPaymentTerms: defaultPaymentTerms,
      lastInvoiceNumber: lastInvoiceNumber,
      themeMode: themeMode,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeString(obj.currencySymbol)
      ..writeDouble(obj.defaultVatRate)
      ..writeInt(obj.defaultPaymentTerms)
      ..writeInt(obj.lastInvoiceNumber)
      ..writeString(obj.themeMode);
  }
}
