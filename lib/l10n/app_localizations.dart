import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('sq')];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localizations != null, 'No AppLocalizations found in context');
    return localizations!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'SmartInvoice',
      'dashboard': 'Dashboard',
      'invoices': 'Invoices',
      'clients': 'Clients',
      'settings': 'Settings',
      'new': 'New',
      'searchClients': 'Search clients',
      'searchInvoices': 'Search by invoice # or client',
      'status': 'Status',
      'all': 'All',
      'paid': 'Paid',
      'unpaid': 'Unpaid',
      'partial': 'Partial',
      'noClientsYet': 'No clients yet.',
      'noInvoicesYet': 'No invoices yet.',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'deleteClient': 'Delete client',
      'deleteClientConfirm': 'Are you sure you want to delete this client?',
      'deleteInvoice': 'Delete invoice',
      'deleteInvoiceConfirm': 'Are you sure you want to delete this invoice? This action cannot be undone.',
      'edit': 'Edit',
      'editClient': 'Edit client',
      'newClient': 'New client',
      'name': 'Name',
      'address': 'Address',
      'city': 'City',
      'country': 'Country',
      'email': 'Email',
      'phone': 'Phone',
      'taxNumber': 'Tax number',
      'required': 'Required',
      'update': 'Update',
      'save': 'Save',
      'overview': 'Overview',
      'totalBilled': 'Total billed',
      'recentInvoices': 'Recent invoices',
      'noInvoicesCreateFirst': 'No invoices yet.\nCreate your first invoice!',
      'language': 'Language',
      'english': 'English',
      'albanian': 'Albanian',
      'companyProfiles': 'Company profiles',
      'selectCompanyToEdit': 'Select company to edit',
      'uploadLogo': 'Upload logo',
      'companyName': 'Company name',
      'bankName': 'Bank name',
      'website': 'Website',
      'companySaved': 'Company saved',
      'saveCompany': 'Save company',
      'updateCompany': 'Update company',
      'savedAsNewCompany': 'Saved as new company',
      'saveAsNew': 'Save as new',
      'deleteCompany': 'Delete company',
      'deleteCompanyConfirm': 'Delete "{name}"? Existing invoices keep their saved company snapshot.',
      'defaults': 'Defaults',
      'currencySymbol': 'Currency symbol',
      'defaultVat': 'Default VAT %',
      'paymentTermsDays': 'Payment terms (days)',
      'appearanceTheme': 'Appearance / Theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'defaultsSaved': 'Defaults saved',
      'saveDefaults': 'Save defaults',
      'editInvoice': 'Edit invoice',
      'newInvoice': 'New invoice',
      'selectCompany': 'Select company',
      'chooseCompany': 'Choose company',
      'selectClient': 'Select client',
      'chooseClient': 'Choose client',
      'enterClientManually': 'Enter client manually',
      'clientName': 'Client name',
      'enterClientName': 'Enter client name',
      'invoiceDate': 'Invoice date',
      'dueDate': 'Due date',
      'paymentTerms': 'Payment terms',
      'dueOnReceipt': 'Due on receipt',
      'days': 'days',
      'vatRate': 'VAT rate %',
      'items': 'Items',
      'addItem': 'Add item',
      'item': 'Item',
      'description': 'Description',
      'quantity': 'Qty',
      'unit': 'Unit',
      'unitPrice': 'Unit price',
      'discount': 'Discount %',
      'lineTotal': 'Line total',
      'subtotal': 'Subtotal',
      'total': 'Total',
      'totalInWords': 'Total in words',
      'addAtLeastOneItem': 'Add at least one item',
      'updateInvoice': 'Update invoice',
      'saveInvoice': 'Save invoice',
      'invoiceNotFound': 'Invoice not found',
      'invoice': 'Invoice',
      'invoiceNumber': 'Invoice #',
      'date': 'Date',
      'due': 'Due',
      'taxLabel': 'Tax',
      'discountLabel': 'discount',
    },
    'sq': {
      'appTitle': 'SmartInvoice',
      'dashboard': 'Paneli',
      'invoices': 'Faturat',
      'clients': 'Klientët',
      'settings': 'Cilësimet',
      'new': 'I ri',
      'searchClients': 'Kërko klientë',
      'searchInvoices': 'Kërko sipas nr. faturës ose klientit',
      'status': 'Statusi',
      'all': 'Të gjitha',
      'paid': 'Paguar',
      'unpaid': 'Papaguar',
      'partial': 'Pjesërisht',
      'noClientsYet': 'Nuk ka ende klientë.',
      'noInvoicesYet': 'Nuk ka ende fatura.',
      'delete': 'Fshi',
      'cancel': 'Anulo',
      'deleteClient': 'Fshi klientin',
      'deleteClientConfirm': 'A je i sigurt që dëshiron ta fshish këtë klient?',
      'deleteInvoice': 'Fshi faturën',
      'deleteInvoiceConfirm': 'A je i sigurt që dëshiron ta fshish këtë faturë? Ky veprim nuk mund të zhbëhet.',
      'edit': 'Ndrysho',
      'editClient': 'Ndrysho klientin',
      'newClient': 'Klient i ri',
      'name': 'Emri',
      'address': 'Adresa',
      'city': 'Qyteti',
      'country': 'Shteti',
      'email': 'Email',
      'phone': 'Telefoni',
      'taxNumber': 'NIPT',
      'required': 'E detyrueshme',
      'update': 'Përditëso',
      'save': 'Ruaj',
      'overview': 'Përmbledhje',
      'totalBilled': 'Totali i faturuar',
      'recentInvoices': 'Faturat e fundit',
      'noInvoicesCreateFirst': 'Nuk ka ende fatura.\nKrijo faturën tënde të parë!',
      'language': 'Gjuha',
      'english': 'Anglisht',
      'albanian': 'Shqip',
      'companyProfiles': 'Profilet e kompanisë',
      'selectCompanyToEdit': 'Zgjidh kompaninë për ta ndryshuar',
      'uploadLogo': 'Ngarko logon',
      'companyName': 'Emri i kompanisë',
      'bankName': 'Emri i bankës',
      'website': 'Faqja e internetit',
      'companySaved': 'Kompania u ruajt',
      'saveCompany': 'Ruaj kompaninë',
      'updateCompany': 'Përditëso kompaninë',
      'savedAsNewCompany': 'U ruajt si kompani e re',
      'saveAsNew': 'Ruaj si e re',
      'deleteCompany': 'Fshi kompaninë',
      'deleteCompanyConfirm': 'Ta fshij "{name}"? Faturat ekzistuese ruajnë të dhënat e kompanisë së ruajtur në to.',
      'defaults': 'Parazgjedhjet',
      'currencySymbol': 'Simboli i monedhës',
      'defaultVat': 'TVSH parazgjedhur %',
      'paymentTermsDays': 'Afati i pagesës (ditë)',
      'appearanceTheme': 'Pamja / Tema',
      'system': 'Sistemi',
      'light': 'Çelët',
      'dark': 'Errët',
      'defaultsSaved': 'Parazgjedhjet u ruajtën',
      'saveDefaults': 'Ruaj parazgjedhjet',
      'editInvoice': 'Ndrysho faturën',
      'newInvoice': 'Faturë e re',
      'selectCompany': 'Zgjidh kompaninë',
      'chooseCompany': 'Zgjidh një kompani',
      'selectClient': 'Zgjidh klientin',
      'chooseClient': 'Zgjidh një klient',
      'enterClientManually': 'Shkruaj klientin manualisht',
      'clientName': 'Emri i klientit',
      'enterClientName': 'Shkruaj emrin e klientit',
      'invoiceDate': 'Data e faturës',
      'dueDate': 'Afati',
      'paymentTerms': 'Kushtet e pagesës',
      'dueOnReceipt': 'Në dorëzim',
      'days': 'ditë',
      'vatRate': 'TVSH %',
      'items': 'Artikujt',
      'addItem': 'Shto artikull',
      'item': 'Artikulli',
      'description': 'Përshkrimi',
      'quantity': 'Sasia',
      'unit': 'Njësia',
      'unitPrice': 'Çmimi për njësi',
      'discount': 'Zbritja %',
      'lineTotal': 'Totali i rreshtit',
      'subtotal': 'Nëntotali',
      'total': 'Totali',
      'totalInWords': 'Totali me fjalë',
      'addAtLeastOneItem': 'Shto të paktën një artikull',
      'updateInvoice': 'Përditëso faturën',
      'saveInvoice': 'Ruaj faturën',
      'invoiceNotFound': 'Fatura nuk u gjet',
      'invoice': 'Fatura',
      'invoiceNumber': 'Nr. i faturës',
      'date': 'Data',
      'due': 'Afati',
      'taxLabel': 'NIPT',
      'discountLabel': 'zbritje',
    },
  };

  String tr(String key) {
    final lang = _localizedValues.containsKey(locale.languageCode) ? locale.languageCode : 'en';
    return _localizedValues[lang]?[key] ?? _localizedValues['en']![key] ?? key;
  }

  String trf(String key, Map<String, String> values) {
    var text = tr(key);
    for (final entry in values.entries) {
      text = text.replaceAll('{${entry.key}}', entry.value);
    }
    return text;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
