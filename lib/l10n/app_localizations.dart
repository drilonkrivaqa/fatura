import 'package:flutter/material.dart';

import '../models/invoice.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const supportedLocales = [Locale('en'), Locale('sq')];

  static const Map<String, Map<String, String>> _v = {
    'en': {
      'appTitle': 'SmartInvoice',
      'dashboard': 'Dashboard',
      'invoices': 'Invoices',
      'clients': 'Clients',
      'settings': 'Settings',
      'language': 'Language',
      'english': 'English',
      'albanian': 'Albanian',
      'required': 'Required',
      'new': 'New',
      'save': 'Save',
      'update': 'Update',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'searchClients': 'Search clients',
      'searchInvoices': 'Search by invoice # or client',
      'noClients': 'No clients yet.',
      'noInvoices': 'No invoices yet.',
      'status': 'Status',
      'all': 'All',
      'paid': 'Paid',
      'unpaid': 'Unpaid',
      'partial': 'Partial',
      'overview': 'Overview',
      'recentInvoices': 'Recent invoices',
      'totalBilled': 'Total billed',
      'companyProfiles': 'Company profiles',
      'defaults': 'Defaults',
      'appearanceTheme': 'Appearance / Theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'saved': 'Saved',
      'invoiceNotFound': 'Invoice not found',
      'subtotal': 'Subtotal',
      'total': 'Total',
      'totalInWords': 'Total in words',
      'items': 'Items',
      'paymentTerms': 'Payment terms',
      'dueOnReceipt': 'Due on receipt',
      'days': 'days',
      'editClient': 'Edit client',
      'newClient': 'New client',
      'name': 'Name',
      'address': 'Address',
      'city': 'City',
      'country': 'Country',
      'email': 'Email',
      'phone': 'Phone',
      'taxNumber': 'Tax number',
      'editInvoice': 'Edit Invoice',
      'newInvoice': 'New Invoice',
      'selectCompany': 'Select company',
      'selectClient': 'Select client',
      'invoiceDate': 'Invoice date',
      'dueDate': 'Due date',
      'currency': 'Currency',
      'defaultVat': 'Default VAT %',
      'paymentTermsDays': 'Payment terms (days)',
      'currencySymbol': 'Currency symbol',
      'uploadLogo': 'Upload logo',
    },
    'sq': {
      'appTitle': 'SmartInvoice',
      'dashboard': 'Paneli',
      'invoices': 'Faturat',
      'clients': 'Klientët',
      'settings': 'Cilësimet',
      'language': 'Gjuha',
      'english': 'Anglisht',
      'albanian': 'Shqip',
      'required': 'E detyrueshme',
      'new': 'I ri',
      'save': 'Ruaj',
      'update': 'Përditëso',
      'cancel': 'Anulo',
      'delete': 'Fshi',
      'searchClients': 'Kërko klientë',
      'searchInvoices': 'Kërko sipas # faturës ose klientit',
      'noClients': 'Ende nuk ka klientë.',
      'noInvoices': 'Ende nuk ka fatura.',
      'status': 'Statusi',
      'all': 'Të gjitha',
      'paid': 'Paguar',
      'unpaid': 'Papaguar',
      'partial': 'Pjesërisht',
      'overview': 'Përmbledhje',
      'recentInvoices': 'Faturat e fundit',
      'totalBilled': 'Totali i faturuar',
      'companyProfiles': 'Profilet e kompanisë',
      'defaults': 'Parazgjedhjet',
      'appearanceTheme': 'Pamja / Tema',
      'system': 'Sistemi',
      'light': 'E çelët',
      'dark': 'E errët',
      'saved': 'U ruajt',
      'invoiceNotFound': 'Fatura nuk u gjet',
      'subtotal': 'Nëntotali',
      'total': 'Totali',
      'totalInWords': 'Totali me fjalë',
      'items': 'Artikujt',
      'paymentTerms': 'Kushtet e pagesës',
      'dueOnReceipt': 'Pagesë në momentin e pranimit',
      'days': 'ditë',
      'editClient': 'Ndrysho klientin',
      'newClient': 'Klient i ri',
      'name': 'Emri',
      'address': 'Adresa',
      'city': 'Qyteti',
      'country': 'Shteti',
      'email': 'Email',
      'phone': 'Telefoni',
      'taxNumber': 'Numri fiskal',
      'editInvoice': 'Ndrysho faturën',
      'newInvoice': 'Faturë e re',
      'selectCompany': 'Zgjidh kompaninë',
      'selectClient': 'Zgjidh klientin',
      'invoiceDate': 'Data e faturës',
      'dueDate': 'Data e afatit',
      'currency': 'Monedha',
      'defaultVat': 'TVSH parazgjedhur %',
      'paymentTermsDays': 'Kushtet e pagesës (ditë)',
      'currencySymbol': 'Simboli i monedhës',
      'uploadLogo': 'Ngarko logon',
    },
  };

  String tr(String key) => _v[locale.languageCode]?[key] ?? _v['en']![key] ?? key;

  String statusLabel(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return tr('paid');
      case InvoiceStatus.partial:
        return tr('partial');
      case InvoiceStatus.unpaid:
        return tr('unpaid');
    }
  }
}

extension LocalizationX on BuildContext {
  AppLocalizations get l10n => AppLocalizations(Localizations.localeOf(this));
}
