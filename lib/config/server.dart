import 'dart:io';

import 'package:flutter/cupertino.dart';

class Server {
  final String name;
  final File image;
  final List<String> invitedFriends;

  Server({required this.name, required this.image, required this.invitedFriends});
}

