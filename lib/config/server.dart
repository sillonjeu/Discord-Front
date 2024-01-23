import 'dart:io';

import 'package:flutter/cupertino.dart';

class Server {
  final String name;
  final File image;
  final List<String> invitedFriends;
  final String description;

  Server({required this.name, required this.image, required this.invitedFriends, required this.description});
}

