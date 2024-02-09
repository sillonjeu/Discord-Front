import 'package:flutter/cupertino.dart';

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ServerMessage{
  String messageContent;
  String user;
  String imageURL;
  ServerMessage({required this.messageContent, required this.user, required this.imageURL});
}