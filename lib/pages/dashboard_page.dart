import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/invoice.dart';
import '../services/client_service.dart';
import '../services/invoice_service.dart';
import '../l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Typed providers
    final invoices = context.watch<InvoiceService>().invoices;
    final clients = context.watch<ClientService>().clients;

    final paidCount =
        invoices.where((i) => i.status == InvoiceStatus.paid).length;
    final unpaidCount =
        invoices.where((i) => i.status == InvoiceStatus.unpaid).length;
    final totalAmount =
    invoices.fold(0.0, (sum, inv) => sum + inv.total);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            context.l10n.overview,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatCard(
                title: context.l10n.clientsCount,
                value: clients.length.toString(),
                icon: Icons.people_alt,
              ),
              _StatCard(
                title: context.l10n.invoicesCount,
                value: invoices.length.toString(),
                icon: Icons.receipt_long,
              ),
              _StatCard(
                title: context.l10n.paid,
                value: paidCount.toString(),
                icon: Icons.check_circle_outline,
              ),
              _StatCard(
                title: context.l10n.unpaid,
                value: unpaidCount.toString(),
                icon: Icons.warning_amber_rounded,
              ),
              _StatCard(
                title: context.l10n.totalBilled,
                value: totalAmount.toStringAsFixed(2),
                icon: Icons.attach_money,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.recentInvoices,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...invoices.take(5).map(
                (inv) => ListTile(
              leading: Icon(
                inv.status == InvoiceStatus.paid
                    ? Icons.check_circle
                    : (inv.status == InvoiceStatus.partial
                    ? Icons.schedule
                    : Icons.schedule),
                color: inv.status == InvoiceStatus.paid
                    ? Colors.green
                    : (inv.status == InvoiceStatus.partial
                    ? Colors.orange
                    : Colors.red),
              ),
              title: Text(inv.invoiceNumber),
              subtitle: Text(inv.clientName),
              trailing: Text(inv.total.toStringAsFixed(2)),
            ),
          ),
          if (invoices.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Center(
                child: Text(context.l10n.noInvoicesYetCreate,
                    textAlign: TextAlign.center),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
