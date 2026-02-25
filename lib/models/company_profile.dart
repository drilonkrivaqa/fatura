import 'package:hive/hive.dart';

class CompanyProfile {
  final String id;
  final String name;
  final String address;
  final String city;
  final String country;
  final String phone;
  final String email;
  final String taxNumber;
  final String bankName;
  final String iban;
  final String website;
  final String logoPath;

  CompanyProfile({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.phone,
    required this.email,
    required this.taxNumber,
    required this.bankName,
    required this.iban,
    required this.website,
    required this.logoPath,
  });

  CompanyProfile copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? country,
    String? phone,
    String? email,
    String? taxNumber,
    String? bankName,
    String? iban,
    String? website,
    String? logoPath,
  }) {
    return CompanyProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      taxNumber: taxNumber ?? this.taxNumber,
      bankName: bankName ?? this.bankName,
      iban: iban ?? this.iban,
      website: website ?? this.website,
      logoPath: logoPath ?? this.logoPath,
    );
  }
}

class CompanyProfileAdapter extends TypeAdapter<CompanyProfile> {
  @override
  final int typeId = 0;

  @override
  CompanyProfile read(BinaryReader reader) {
    final legacyName = reader.readString();
    final legacyAddress = reader.readString();
    final legacyCity = reader.readString();
    final legacyCountry = reader.readString();
    final legacyPhone = reader.readString();
    final legacyEmail = reader.readString();
    final legacyTaxNumber = reader.readString();
    final legacyBankName = reader.readString();
    final legacyIban = reader.readString();
    final legacyWebsite = reader.readString();
    final legacyLogoPath = reader.readString();
    final storedId = reader.availableBytes > 0 ? reader.readString() : '';

    return CompanyProfile(
      id: storedId.isNotEmpty ? storedId : _legacyId(legacyName, legacyTaxNumber),
      name: legacyName,
      address: legacyAddress,
      city: legacyCity,
      country: legacyCountry,
      phone: legacyPhone,
      email: legacyEmail,
      taxNumber: legacyTaxNumber,
      bankName: legacyBankName,
      iban: legacyIban,
      website: legacyWebsite,
      logoPath: legacyLogoPath,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyProfile obj) {
    writer
      ..writeString(obj.name)
      ..writeString(obj.address)
      ..writeString(obj.city)
      ..writeString(obj.country)
      ..writeString(obj.phone)
      ..writeString(obj.email)
      ..writeString(obj.taxNumber)
      ..writeString(obj.bankName)
      ..writeString(obj.iban)
      ..writeString(obj.website)
      ..writeString(obj.logoPath)
      ..writeString(obj.id);
  }

  String _legacyId(String name, String taxNumber) {
    final basis = '${name.trim()}-${taxNumber.trim()}';
    return basis.isNotEmpty ? basis.hashCode.toString() : 'company-default';
  }
}
