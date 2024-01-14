import 'dart:io';
import 'package:flutter/material.dart';
import 'server.dart';

class ServerList with ChangeNotifier {
  List<Server> _servers = [];

  List<Server> get servers => _servers;

  void addServer(Server server) {
    _servers.add(server);
    notifyListeners();
  }
}
