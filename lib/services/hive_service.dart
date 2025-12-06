import 'package:hive_flutter/hive_flutter.dart';

import '../models/app_settings.dart';
import '../models/client.dart';
import '../models/company_profile.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';

class HiveService {
  static const String companyBoxName = 'company_profile';
  static const String clientsBoxName = 'clients';
  static const String invoicesBoxName = 'invoices';
  static const String settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(CompanyProfileAdapter().typeId)) {
      Hive.registerAdapter(CompanyProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(ClientAdapter().typeId)) {
      Hive.registerAdapter(ClientAdapter());
    }
    if (!Hive.isAdapterRegistered(InvoiceItemAdapter().typeId)) {
      Hive.registerAdapter(InvoiceItemAdapter());
    }
    if (!Hive.isAdapterRegistered(InvoiceStatusAdapter().typeId)) {
      Hive.registerAdapter(InvoiceStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(InvoiceAdapter().typeId)) {
      Hive.registerAdapter(InvoiceAdapter());
    }
    if (!Hive.isAdapterRegistered(AppSettingsAdapter().typeId)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }

    await Hive.openBox<CompanyProfile>(companyBoxName);
    await Hive.openBox<Client>(clientsBoxName);
    await Hive.openBox<Invoice>(invoicesBoxName);
    await Hive.openBox<AppSettings>(settingsBoxName);
  }

  static Box<CompanyProfile> companyBox() => Hive.box<CompanyProfile>(companyBoxName);

  static Box<Client> clientsBox() => Hive.box<Client>(clientsBoxName);

  static Box<Invoice> invoicesBox() => Hive.box<Invoice>(invoicesBoxName);

  static Box<AppSettings> settingsBox() => Hive.box<AppSettings>(settingsBoxName);
}
