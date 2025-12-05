import 'package:hive/hive.dart';

class CompanyProfile {
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
    return CompanyProfile(
      name: reader.readString(),
      address: reader.readString(),
      city: reader.readString(),
      country: reader.readString(),
      phone: reader.readString(),
      email: reader.readString(),
      taxNumber: reader.readString(),
      bankName: reader.readString(),
      iban: reader.readString(),
      website: reader.readString(),
      logoPath: reader.readString(),
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
      ..writeString(obj.logoPath);
  }
}
