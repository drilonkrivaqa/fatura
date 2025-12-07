import 'package:flutter/material.dart';

import 'clients_page.dart';
import 'dashboard_page.dart';
import 'invoices_page.dart';
import 'settings_page.dart';
import '../l10n/app_localizations.dart';

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
        title: Text(context.l10n.appTitle),
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
          NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: context.l10n.dashboard),
          NavigationDestination(icon: const Icon(Icons.receipt_long), label: context.l10n.invoices),
          NavigationDestination(icon: const Icon(Icons.people_alt_outlined), label: context.l10n.clients),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: context.l10n.settings),
        ],
      ),
    );
  }
}
