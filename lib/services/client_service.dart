import 'package:flutter/material.dart';

import '../models/client.dart';
import 'hive_service.dart';

class ClientService extends ChangeNotifier {
  List<Client> _clients = [];

  List<Client> get clients => _clients;

  ClientService() {
    loadClients();
  }

  void loadClients() {
    final box = HiveService.clientsBox();
    _clients = box.values.toList();
    notifyListeners();
  }

  Future<void> addClient(Client client) async {
    final box = HiveService.clientsBox();
    await box.put(client.id, client);
    _clients = box.values.toList();
    notifyListeners();
  }

  Future<void> updateClient(Client client) async {
    final box = HiveService.clientsBox();
    await box.put(client.id, client);
    _clients = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteClient(String id) async {
    final box = HiveService.clientsBox();
    await box.delete(id);
    _clients = box.values.toList();
    notifyListeners();
  }

  Client? findById(String id) {
    try {
      return _clients.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
