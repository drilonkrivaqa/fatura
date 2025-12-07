import 'package:hive/hive.dart';

class AppSettings {
  final String currencySymbol;
  final double defaultVatRate;
  final int defaultPaymentTerms;
  final int lastInvoiceNumber;
  final String themeMode; // allowed values: 'system', 'light', 'dark'
  final String localeCode; // e.g. 'en', 'sq'

  AppSettings({
    required this.currencySymbol,
    required this.defaultVatRate,
    required this.defaultPaymentTerms,
    required this.lastInvoiceNumber,
    required this.themeMode,
    required this.localeCode,
  });

  AppSettings copyWith({
    String? currencySymbol,
    double? defaultVatRate,
    int? defaultPaymentTerms,
    int? lastInvoiceNumber,
    String? themeMode,
    String? localeCode,
  }) {
    return AppSettings(
      currencySymbol: currencySymbol ?? this.currencySymbol,
      defaultVatRate: defaultVatRate ?? this.defaultVatRate,
      defaultPaymentTerms: defaultPaymentTerms ?? this.defaultPaymentTerms,
      lastInvoiceNumber: lastInvoiceNumber ?? this.lastInvoiceNumber,
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
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
    final localeCode = reader.availableBytes > 0 ? reader.readString() : 'en';

    return AppSettings(
      currencySymbol: currencySymbol,
      defaultVatRate: defaultVatRate,
      defaultPaymentTerms: defaultPaymentTerms,
      lastInvoiceNumber: lastInvoiceNumber,
      themeMode: themeMode,
      localeCode: localeCode,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeString(obj.currencySymbol)
      ..writeDouble(obj.defaultVatRate)
      ..writeInt(obj.defaultPaymentTerms)
      ..writeInt(obj.lastInvoiceNumber)
      ..writeString(obj.themeMode)
      ..writeString(obj.localeCode);
  }
}
