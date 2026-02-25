import 'package:flutter/widgets.dart';

class AppL10n {
  AppL10n(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('sq')];

  static const Map<String, String> _sq = {
    'Dashboard': 'Paneli',
    'Invoices': 'Faturat',
    'Clients': 'Klientët',
    'Settings': 'Cilësimet',
    'Overview': 'Përmbledhje',
    'Paid': 'E paguar',
    'Unpaid': 'E papaguar',
    'Total billed': 'Totali i faturuar',
    'Recent invoices': 'Faturat e fundit',
    'No invoices yet.\nCreate your first invoice!': 'Nuk ka ende fatura.\nKrijoni faturën tuaj të parë!',
    'Search clients': 'Kërko klientë',
    'New': 'I ri',
    'No clients yet.': 'Nuk ka ende klientë.',
    'Delete client': 'Fshi klientin',
    'Are you sure you want to delete this client?': 'A jeni i sigurt që dëshironi ta fshini këtë klient?',
    'Cancel': 'Anulo',
    'Delete': 'Fshi',
    'Search invoices': 'Kërko fatura',
    'All': 'Të gjitha',
    'No invoices found.': 'Nuk u gjetën fatura.',
    'Invoice details': 'Detajet e faturës',
    'Company': 'Kompania',
    'Bill to': 'Faturuar për',
    'Issue date': 'Data e lëshimit',
    'Due date': 'Data e afatit',
    'Payment terms': 'Kushtet e pagesës',
    'Items': 'Artikujt',
    'Description': 'Përshkrimi',
    'Qty': 'Sasia',
    'Unit': 'Njësia',
    'Unit price': 'Çmimi për njësi',
    'Discount': 'Zbritja',
    'Subtotal': 'Nëntotali',
    'VAT': 'TVSH',
    'Total': 'Totali',
    'Mark as paid': 'Shëno si e paguar',
    'Generate PDF': 'Gjenero PDF',
    'Delete invoice': 'Fshi faturën',
    'Edit Invoice': 'Ndrysho faturën',
    'New Invoice': 'Faturë e re',
    'Select company': 'Zgjidh kompaninë',
    'Choose company': 'Zgjidh kompaninë',
    'Select client': 'Zgjidh klientin',
    'Choose client': 'Zgjidh klientin',
    'Enter client manually': 'Shkruaj klientin manualisht',
    'Client name': 'Emri i klientit',
    'Enter client name': 'Shkruaj emrin e klientit',
    'Address': 'Adresa',
    'City': 'Qyteti',
    'Country': 'Shteti',
    'Email': 'Email',
    'Phone': 'Telefoni',
    'Tax number': 'Numri fiskal',
    'Invoice date': 'Data e faturës',
    'Due date ': 'Data e afatit ',
    'VAT rate %': 'Norma TVSH %',
    'Status': 'Statusi',
    'Partial': 'Pjesërisht',
    'Add item': 'Shto artikull',
    'Quantity': 'Sasia',
    'Discount %': 'Zbritja %',
    'Line total:': 'Totali i rreshtit:',
    'Appearance / Theme': 'Pamja / Tema',
    'System': 'Sistem',
    'Light': 'E çelët',
    'Dark': 'E errët',
    'Save defaults': 'Ruaj parazgjedhjet',
    'Defaults saved': 'Parazgjedhjet u ruajtën',
    'Currency symbol': 'Simboli i monedhës',
    'Default VAT %': 'TVSH parazgjedhur %',
    'Payment terms (days)': 'Afati i pagesës (ditë)',
    'Create client': 'Krijo klient',
    'Edit client': 'Ndrysho klientin',
    'Save': 'Ruaj',
    'SmartInvoice': 'SmartInvoice',
    'Edit': 'Ndrysho',
    'Update': 'Përditëso',
    'Required': 'E detyrueshme',
    'Are you sure you want to delete this invoice? This action cannot be undone.': 'A jeni i sigurt që dëshironi ta fshini këtë faturë? Ky veprim nuk mund të zhbëhet.',
    'Company profiles': 'Profilet e kompanisë',
    'Select company to edit': 'Zgjidh kompaninë për ndryshim',
    'Upload logo': 'Ngarko logon',
    'Company name': 'Emri i kompanisë',
    'Bank name': 'Emri i bankës',
    'Website': 'Uebfaqja',
    'Company saved': 'Kompania u ruajt',
    'Save company': 'Ruaj kompaninë',
    'Update company': 'Përditëso kompaninë',
    'Saved as new company': 'U ruajt si kompani e re',
    'Save as new': 'Ruaj si të re',
    'Delete company': 'Fshi kompaninë',
    'Existing invoices keep their saved company snapshot.': 'Faturat ekzistuese ruajnë të dhënat e kompanisë së ruajtur më herët.',
    'Defaults': 'Parazgjedhjet',
  };

  String t(String key) {
    if (locale.languageCode == 'sq') {
      return _sq[key] ?? key;
    }
    return key;
  }
}

extension L10nBuildContext on BuildContext {
  String t(String key) => AppL10n(Localizations.localeOf(this)).t(key);
}
