import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../services/client_service.dart';
import 'client_form_page.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State createState() => _ClientsPageState();
}

class _ClientsPageState extends State {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final clients = context.watch<ClientService>().clients;

    final filtered = clients.where((c) => c.name.toLowerCase().contains(_search.toLowerCase())).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: context.l10n.tr('searchClients'),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) => setState(() => _search = value),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientFormPage(isEditing: false)),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(context.l10n.tr('new')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(context.l10n.tr('noClientsYet')))
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final client = filtered[index];
                        return ListTile(
                          title: Text(client.name),
                          subtitle: Text('${client.city}, ${client.country}\n${client.email}'),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ClientFormPage(isEditing: true, client: client),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(context.l10n.tr('deleteClient')),
                                      content: Text(context.l10n.tr('deleteClientConfirm')),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: Text(context.l10n.tr('cancel')),
                                        ),
                                        FilledButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: Text(context.l10n.tr('delete')),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await context.read<ClientService>().deleteClient(client.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
