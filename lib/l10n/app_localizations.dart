import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../models/invoice.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const supportedLocales = [Locale('en'), Locale('sq')];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'SmartInvoice',
      'dashboard': 'Dashboard',
      'invoices': 'Invoices',
      'clients': 'Clients',
      'settings': 'Settings',
      'overview': 'Overview',
      'clientsCount': 'Clients',
      'invoicesCount': 'Invoices',
      'paid': 'Paid',
      'unpaid': 'Unpaid',
      'partial': 'Partial',
      'totalBilled': 'Total billed',
      'recentInvoices': 'Recent invoices',
      'noInvoicesYetCreate': 'No invoices yet.\nCreate your first invoice!',
      'noInvoicesYet': 'No invoices yet.',
      'searchInvoice': 'Search by invoice # or client',
      'status': 'Status',
      'all': 'All',
      'new': 'New',
      'deleteInvoice': 'Delete invoice',
      'deleteInvoiceQuestion':
          'Are you sure you want to delete this invoice? This action cannot be undone.',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'invoiceNotFound': 'Invoice not found',
      'invoiceNumber': 'Invoice #',
      'date': 'Date',
      'due': 'Due',
      'paymentTerms': 'Payment terms',
      'items': 'Items',
      'subtotal': 'Subtotal',
      'total': 'Total',
      'totalInWords': 'Total in words',
      'clientName': 'Client name',
      'address': 'Address',
      'city': 'City',
      'country': 'Country',
      'email': 'Email',
      'phone': 'Phone',
      'taxNumber': 'Tax number',
      'invoiceDate': 'Invoice date',
      'dueDate': 'Due date',
      'vatRate': 'VAT rate %',
      'invoiceStatus': 'Status',
      'enterClientManually': 'Enter client manually',
      'selectClient': 'Select client',
      'chooseClient': 'Choose client',
      'enterClientName': 'Enter client name',
      'paymentTermsLabel': 'Payment terms',
      'dueOnReceipt': 'Due on receipt',
      'days': 'days',
      'paidStatus': 'Paid',
      'unpaidStatus': 'Unpaid',
      'partialStatus': 'Partial',
      'description': 'Description',
      'quantity': 'Quantity',
      'unit': 'Unit',
      'unitPrice': 'Unit price',
      'discount': 'Discount %',
      'lineTotal': 'Line total',
      'addItem': 'Add item',
      'item': 'Item',
      'invalidQuantity': 'Enter quantity',
      'invalidPrice': 'Enter price',
      'saveInvoice': 'Save invoice',
      'newInvoice': 'New Invoice',
      'editInvoice': 'Edit Invoice',
      'searchClients': 'Search clients',
      'noClientsYet': 'No clients yet.',
      'deleteClient': 'Delete client',
      'deleteClientQuestion': 'Are you sure you want to delete this client?',
      'newClient': 'New',
      'clientCityCountry': '{city}, {country}',
      'required': 'Required',
      'companyProfile': 'Company profile',
      'uploadLogo': 'Upload logo',
      'companyName': 'Company name',
      'bankName': 'Bank name',
      'iban': 'IBAN',
      'website': 'Website',
      'defaults': 'Defaults',
      'currencySymbol': 'Currency symbol',
      'defaultVat': 'Default VAT %',
      'paymentTermsDays': 'Payment terms (days)',
      'appearanceTheme': 'Appearance / Theme',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'settingsSaved': 'Settings saved',
      'saveSettings': 'Save settings',
      'uploadLogoTooltip': 'Upload logo',
      'invoice': 'Invoice',
      'billTo': 'Bill To',
      'descriptionHeader': 'Description',
      'qtyHeader': 'Qty',
      'unitHeader': 'Unit',
      'unitPriceHeader': 'Unit price',
      'discountHeader': 'Discount',
      'lineTotalHeader': 'Line total',
      'thankYou': 'Thank you for your business!',
      'statusLabel': 'Status',
      'totalLabel': 'TOTAL',
      'language': 'Language',
      'english': 'English',
      'albanian': 'Albanian',
    },
    'sq': {
      'appTitle': 'SmartInvoice',
      'dashboard': 'Pult',
      'invoices': 'Fatura',
      'clients': 'Klientë',
      'settings': 'Cilësimet',
      'overview': 'Përmbledhje',
      'clientsCount': 'Klientë',
      'invoicesCount': 'Fatura',
      'paid': 'Të paguara',
      'unpaid': 'Të papaguara',
      'partial': 'Pjesërisht',
      'totalBilled': 'Totali i faturuar',
      'recentInvoices': 'Faturat e fundit',
      'noInvoicesYetCreate': 'Ende nuk ka fatura.\nKrijoni faturën e parë!',
      'noInvoicesYet': 'Ende nuk ka fatura.',
      'searchInvoice': 'Kërko sipas # faturës ose klientit',
      'status': 'Statusi',
      'all': 'Të gjitha',
      'new': 'E re',
      'deleteInvoice': 'Fshi faturën',
      'deleteInvoiceQuestion':
          'Jeni i sigurt që doni të fshini këtë faturë? Ky veprim nuk mund të zhbëhet.',
      'cancel': 'Anulo',
      'delete': 'Fshi',
      'edit': 'Redakto',
      'invoiceNotFound': 'Fatura nuk u gjet',
      'invoiceNumber': 'Fatura #',
      'date': 'Data',
      'due': 'Afati',
      'paymentTerms': 'Kushtet e pagesës',
      'items': 'Artikujt',
      'subtotal': 'Nëntotali',
      'total': 'Totali',
      'totalInWords': 'Totali me fjalë',
      'clientName': 'Emri i klientit',
      'address': 'Adresa',
      'city': 'Qyteti',
      'country': 'Shteti',
      'email': 'Email',
      'phone': 'Telefoni',
      'taxNumber': 'Numri i tatimit',
      'invoiceDate': 'Data e faturës',
      'dueDate': 'Data e afatit',
      'vatRate': 'TVSH %',
      'invoiceStatus': 'Statusi',
      'enterClientManually': 'Shkruaj klientin manualisht',
      'selectClient': 'Zgjidh klientin',
      'chooseClient': 'Zgjidh klientin',
      'enterClientName': 'Shkruani emrin e klientit',
      'paymentTermsLabel': 'Kushtet e pagesës',
      'dueOnReceipt': 'Pagesë me marrje',
      'days': 'ditë',
      'paidStatus': 'Paguar',
      'unpaidStatus': 'Papaguar',
      'partialStatus': 'Pjesërisht',
      'description': 'Përshkrimi',
      'quantity': 'Sasia',
      'unit': 'Njesia',
      'unitPrice': 'Çmimi për njësi',
      'discount': 'Zbritje %',
      'lineTotal': 'Totali i rreshtit',
      'addItem': 'Shto artikull',
      'item': 'Artikulli',
      'invalidQuantity': 'Shkruani sasinë',
      'invalidPrice': 'Shkruani çmimin',
      'saveInvoice': 'Ruaj faturën',
      'newInvoice': 'Faturë e re',
      'editInvoice': 'Ndrysho faturën',
      'searchClients': 'Kërko klientët',
      'noClientsYet': 'Ende nuk ka klientë.',
      'deleteClient': 'Fshi klientin',
      'deleteClientQuestion': 'Jeni i sigurt që doni të fshini këtë klient?',
      'newClient': 'E re',
      'clientCityCountry': '{city}, {country}',
      'required': 'E detyrueshme',
      'companyProfile': 'Profili i kompanisë',
      'uploadLogo': 'Ngarko logon',
      'companyName': 'Emri i kompanisë',
      'bankName': 'Emri i bankës',
      'iban': 'IBAN',
      'website': 'Faqja e internetit',
      'defaults': 'Parazgjedhjet',
      'currencySymbol': 'Simboli i monedhës',
      'defaultVat': 'TVSH e parazgjedhur %',
      'paymentTermsDays': 'Kushtet e pagesës (ditë)',
      'appearanceTheme': 'Pamja / Tema',
      'system': 'Sistemi',
      'light': 'E çelët',
      'dark': 'E errët',
      'settingsSaved': 'Cilësimet u ruajtën',
      'saveSettings': 'Ruaj cilësimet',
      'uploadLogoTooltip': 'Ngarko logon',
      'invoice': 'Fatura',
      'billTo': 'Faturuar tek',
      'descriptionHeader': 'Përshkrimi',
      'qtyHeader': 'Sasia',
      'unitHeader': 'Njësia',
      'unitPriceHeader': 'Çmimi për njësi',
      'discountHeader': 'Zbritja',
      'lineTotalHeader': 'Totali i rreshtit',
      'thankYou': 'Faleminderit për bashkëpunimin!',
      'statusLabel': 'Statusi',
      'totalLabel': 'TOTALI',
      'language': 'Gjuha',
      'english': 'Anglisht',
      'albanian': 'Shqip',
    },
  };

  String _translate(String key) {
    final languageCode = locale.languageCode;
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get appTitle => _translate('appTitle');
  String get dashboard => _translate('dashboard');
  String get invoices => _translate('invoices');
  String get clients => _translate('clients');
  String get settings => _translate('settings');
  String get overview => _translate('overview');
  String get clientsCount => _translate('clientsCount');
  String get invoicesCount => _translate('invoicesCount');
  String get paid => _translate('paid');
  String get unpaid => _translate('unpaid');
  String get partial => _translate('partial');
  String get totalBilled => _translate('totalBilled');
  String get recentInvoices => _translate('recentInvoices');
  String get noInvoicesYetCreate => _translate('noInvoicesYetCreate');
  String get noInvoicesYet => _translate('noInvoicesYet');
  String get searchInvoice => _translate('searchInvoice');
  String get status => _translate('status');
  String get all => _translate('all');
  String get newLabel => _translate('new');
  String get deleteInvoice => _translate('deleteInvoice');
  String get deleteInvoiceQuestion => _translate('deleteInvoiceQuestion');
  String get cancel => _translate('cancel');
  String get delete => _translate('delete');
  String get edit => _translate('edit');
  String get invoiceNotFound => _translate('invoiceNotFound');
  String get invoiceNumber => _translate('invoiceNumber');
  String get date => _translate('date');
  String get due => _translate('due');
  String get paymentTerms => _translate('paymentTerms');
  String get items => _translate('items');
  String get subtotal => _translate('subtotal');
  String get total => _translate('total');
  String get totalInWords => _translate('totalInWords');
  String get clientName => _translate('clientName');
  String get address => _translate('address');
  String get city => _translate('city');
  String get country => _translate('country');
  String get email => _translate('email');
  String get phone => _translate('phone');
  String get taxNumber => _translate('taxNumber');
  String get invoiceDate => _translate('invoiceDate');
  String get dueDate => _translate('dueDate');
  String get vatRate => _translate('vatRate');
  String get invoiceStatus => _translate('invoiceStatus');
  String get enterClientManually => _translate('enterClientManually');
  String get selectClient => _translate('selectClient');
  String get chooseClient => _translate('chooseClient');
  String get enterClientName => _translate('enterClientName');
  String get paymentTermsLabel => _translate('paymentTermsLabel');
  String get dueOnReceipt => _translate('dueOnReceipt');
  String get days => _translate('days');
  String get paidStatus => _translate('paidStatus');
  String get unpaidStatus => _translate('unpaidStatus');
  String get partialStatus => _translate('partialStatus');
  String get description => _translate('description');
  String get quantity => _translate('quantity');
  String get unit => _translate('unit');
  String get unitPrice => _translate('unitPrice');
  String get discount => _translate('discount');
  String get lineTotal => _translate('lineTotal');
  String get addItem => _translate('addItem');
  String get item => _translate('item');
  String get invalidQuantity => _translate('invalidQuantity');
  String get invalidPrice => _translate('invalidPrice');
  String get saveInvoice => _translate('saveInvoice');
  String get newInvoice => _translate('newInvoice');
  String get editInvoice => _translate('editInvoice');
  String get searchClients => _translate('searchClients');
  String get noClientsYet => _translate('noClientsYet');
  String get deleteClient => _translate('deleteClient');
  String get deleteClientQuestion => _translate('deleteClientQuestion');
  String get newClient => _translate('newClient');
  String get required => _translate('required');
  String get companyProfile => _translate('companyProfile');
  String get uploadLogo => _translate('uploadLogo');
  String get companyName => _translate('companyName');
  String get bankName => _translate('bankName');
  String get iban => _translate('iban');
  String get website => _translate('website');
  String get defaults => _translate('defaults');
  String get currencySymbol => _translate('currencySymbol');
  String get defaultVat => _translate('defaultVat');
  String get paymentTermsDays => _translate('paymentTermsDays');
  String get appearanceTheme => _translate('appearanceTheme');
  String get system => _translate('system');
  String get light => _translate('light');
  String get dark => _translate('dark');
  String get settingsSaved => _translate('settingsSaved');
  String get saveSettings => _translate('saveSettings');
  String get uploadLogoTooltip => _translate('uploadLogoTooltip');
  String get invoiceLabel => _translate('invoice');
  String get billTo => _translate('billTo');
  String get descriptionHeader => _translate('descriptionHeader');
  String get qtyHeader => _translate('qtyHeader');
  String get unitHeader => _translate('unitHeader');
  String get unitPriceHeader => _translate('unitPriceHeader');
  String get discountHeader => _translate('discountHeader');
  String get lineTotalHeader => _translate('lineTotalHeader');
  String get thankYou => _translate('thankYou');
  String get statusLabel => _translate('statusLabel');
  String get totalLabel => _translate('totalLabel');
  String get language => _translate('language');
  String get english => _translate('english');
  String get albanian => _translate('albanian');

  String replaceCityCountry(String city, String country) {
    final template = _translate('clientCityCountry');
    return template.replaceAll('{city}', city).replaceAll('{country}', country);
  }

  String invoiceStatusLabel(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.paid:
        return paidStatus;
      case InvoiceStatus.partial:
        return partialStatus;
      case InvoiceStatus.unpaid:
      default:
        return unpaidStatus;
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations(Localizations.localeOf(this));
}
