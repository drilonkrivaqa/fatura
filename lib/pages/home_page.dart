import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'client_form_page.dart';
import 'clients_page.dart';
import 'dashboard_page.dart';
import 'invoice_form_page.dart';
import 'invoices_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String _pageTitle(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return context.l10n.tr('dashboard');
      case 1:
        return context.l10n.tr('invoices');
      case 2:
        return context.l10n.tr('clients');
      default:
        return context.l10n.tr('settings');
    }
  }

  String _pageSubtitle(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return context.l10n.tr('overview');
      case 1:
        return context.l10n.tr('recentInvoices');
      case 2:
        return context.l10n.tr('companyProfiles');
      default:
        return context.l10n.tr('defaults');
    }
  }

  Future<void> _openQuickCreate(BuildContext context) async {
    if (_selectedIndex == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InvoiceFormPage()),
      );
    } else if (_selectedIndex == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ClientFormPage(isEditing: false)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [
      DashboardPage(),
      InvoicesPage(),
      ClientsPage(),
      SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_pageTitle(context)),
            Text(
              _pageSubtitle(context),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      floatingActionButton: (_selectedIndex == 1 || _selectedIndex == 2)
          ? FloatingActionButton.extended(
              onPressed: () => _openQuickCreate(context),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.tr('new')),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            label: context.l10n.tr('dashboard'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long),
            label: context.l10n.tr('invoices'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_alt_outlined),
            label: context.l10n.tr('clients'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: context.l10n.tr('settings'),
          ),
        ],
      ),
    );
  }
}
