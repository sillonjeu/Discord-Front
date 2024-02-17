import 'package:flutter/cupertino.dart';
import 'package:Discord-Front/stompfunc.dart';

class Servers implements JsonSerializable{
  final String name;
  final int users;
  final String initialmessage;
  final String imageURL;
  final String time;

  Servers({required this.name, required this.users, required this.initialmessage, required this.imageURL, required this.time});

  @override
  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'users' : users,
      'initialmessage' : initialmessage,
      'imageURL' : imageURL,
      'time' : time,
    };
  }
}