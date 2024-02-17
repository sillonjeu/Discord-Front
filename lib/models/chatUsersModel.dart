import 'package:flutter/cupertino.dart';
import 'package:Discord-Front/stompfunc.dart';

class ChatUsers implements JsonSerializable{
  final String name;
  final String messageText;
  final String imageURL;
  final String time;

  ChatUsers({required this.name, required this.messageText, required this.imageURL,required this.time});

  @override
   Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'messageText' : messageText,
      'imageURL' : imageURL,
      'time' : time,
    };
  }

  factory ChatUsers.fromJson(Map<String, dynamic> json) {
    return ChatUsers(
      name : json['name'],
      messageText : json['messageText'],
      imageURL: json['imageURL'],
      time: json['time']
    );
  }
}