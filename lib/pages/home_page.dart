import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'clients_page.dart';
import 'dashboard_page.dart';
import 'invoices_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
        title: Text(context.l10n.tr('appTitle')),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
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
