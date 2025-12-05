import 'package:hive/hive.dart';

class Client {
  final String id;
  final String name;
  final String address;
  final String city;
  final String country;
  final String email;
  final String phone;
  final String taxNumber;

  Client({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.email,
    required this.phone,
    required this.taxNumber,
  });

  Client copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? country,
    String? email,
    String? phone,
    String? taxNumber,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      taxNumber: taxNumber ?? this.taxNumber,
    );
  }
}

class ClientAdapter extends TypeAdapter<Client> {
  @override
  final int typeId = 1;

  @override
  Client read(BinaryReader reader) {
    return Client(
      id: reader.readString(),
      name: reader.readString(),
      address: reader.readString(),
      city: reader.readString(),
      country: reader.readString(),
      email: reader.readString(),
      phone: reader.readString(),
      taxNumber: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Client obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.address)
      ..writeString(obj.city)
      ..writeString(obj.country)
      ..writeString(obj.email)
      ..writeString(obj.phone)
      ..writeString(obj.taxNumber);
  }
}
