import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/invoice.dart';
import '../services/client_service.dart';
import '../services/invoice_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final invoices = context.watch<InvoiceService>().invoices;
    final clients = context.watch<ClientService>().clients;

    final paidCount = invoices.where((i) => i.status == InvoiceStatus.paid).length;
    final unpaidCount = invoices.where((i) => i.status == InvoiceStatus.unpaid).length;
    final partialCount = invoices.where((i) => i.status == InvoiceStatus.partial).length;
    final totalAmount = invoices.fold(0.0, (sum, inv) => sum + inv.total);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          context.l10n.tr('overview'),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: [
            _StatCard(
              title: context.l10n.tr('clients'),
              value: clients.length.toString(),
              icon: Icons.people_alt,
              accent: const Color(0xFF1E88E5),
            ),
            _StatCard(
              title: context.l10n.tr('invoices'),
              value: invoices.length.toString(),
              icon: Icons.receipt_long,
              accent: const Color(0xFF5E35B1),
            ),
            _StatCard(
              title: context.l10n.tr('paid'),
              value: paidCount.toString(),
              icon: Icons.check_circle_outline,
              accent: const Color(0xFF2E7D32),
            ),
            _StatCard(
              title: context.l10n.tr('unpaid'),
              value: unpaidCount.toString(),
              icon: Icons.warning_amber_rounded,
              accent: const Color(0xFFEF6C00),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.account_balance_wallet_outlined),
            ),
            title: Text(context.l10n.tr('totalBilled')),
            subtitle: Text('${context.l10n.tr('partial')}: $partialCount'),
            trailing: Text(
              totalAmount.toStringAsFixed(2),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.tr('recentInvoices'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (invoices.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(context.l10n.tr('noInvoicesCreateFirst')),
              ),
            ),
          )
        else
          ...invoices.take(5).map(
                (inv) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: _StatusAvatar(status: inv.status),
                    title: Text(inv.invoiceNumber),
                    subtitle: Text(inv.clientName),
                    trailing: Text(inv.total.toStringAsFixed(2)),
                  ),
                ),
              ),
      ],
    );
  }
}

class _StatusAvatar extends StatelessWidget {
  const _StatusAvatar({required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      InvoiceStatus.paid => (Icons.check_circle, Colors.green),
      InvoiceStatus.partial => (Icons.timelapse, Colors.orange),
      InvoiceStatus.unpaid => (Icons.pending_actions, Colors.red),
    };

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.12),
      child: Icon(icon, color: color),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: accent.withOpacity(0.15),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
