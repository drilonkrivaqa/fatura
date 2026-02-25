import 'package:flutter/material.dart';

import '../l10n.dart';

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
        title: Text(context.t('SmartInvoice')),
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
          NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: context.t('Dashboard')),
          NavigationDestination(icon: const Icon(Icons.receipt_long), label: context.t('Invoices')),
          NavigationDestination(icon: const Icon(Icons.people_alt_outlined), label: context.t('Clients')),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: context.t('Settings')),
        ],
      ),
    );
  }
}
