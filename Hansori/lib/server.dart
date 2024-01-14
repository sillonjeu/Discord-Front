import 'dart:io';

class Server {
  String name;
  List<String> invitedFriends;
  File? image;

  Server({required this.name, required this.invitedFriends, this.image});
}