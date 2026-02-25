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
    },
  };

  String tr(String key) {
    final lang = _localizedValues.containsKey(locale.languageCode) ? locale.languageCode : 'en';
    return _localizedValues[lang]?[key] ?? _localizedValues['en']![key] ?? key;
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
