import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:Discord-Front/stompfunc.dart';
//fromJson 메소드까지 구현하기
class Content implements JsonSerializable{
  int id;
  int userID;
  String nickname;
  String imageCode;
  String message;
  String createdAt;
  bool updated;

  Content({required this.id, required this.userID, required this.nickname, required this.imageCode, required this.message, required this.createdAt, required this.updated});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id' :id,
      'userID': userID,
      'nickname': nickname,
      'imageCode': imageCode,
      'message': message,
      'createdAt' : createdAt,
      'updated': updated
    };
  }

  factory Content.fromJson(Map<String, dynamic> json){
    return Content(
      id: json['id'],
      userID: json['userID'],
      nickname: json['nickname'],
      imageCode: json['imageCode'],
      message: json['message'],
      createdAt: json['createdAt'],
      updated: json['updated'],
    );
  }

}

class Standard implements JsonSerializable
{
  bool isempty;
  bool issorted;
  bool isunsorted;

  Standard({required this.isempty, required this.issorted, required this.isunsorted});

  @override
  Map<String, dynamic> toJson() {
    return {
      'isempty' : isempty,
      'issorted' : issorted,
      'isunsorted' : isunsorted
    };
  }

  factory Standard.fromJson(Map<String, dynamic> json){
    return Standard(
      isempty: json['isempty'],
      issorted: json['issorted'],
      isunsorted: json['isunsorted'],
    );
  }
}

//개인메시지 , 아래랑 호환되면 없앨 예정
class ChatMessage implements JsonSerializable{
  final String messageContent;
  final String messageType;

  ChatMessage({required this.messageContent, required this.messageType});

  @override
  Map<String, dynamic> toJson() {
    return {
      'messageContent' : messageContent,
      'messageType' : messageType,
    };
  }
}

class ServerMessage implements JsonSerializable{
  final Content content;
  final int size;
  final int number;
  final Standard sort;
  final bool first;
  final bool last;
  final int numberofElements;
  final bool empty;

  ServerMessage({required this.content, required this.size, required this.number, required this.sort, required this.first, required this.last, required this.numberofElements, required this.empty});

  @override
  Map<String, dynamic> toJson() {
    return {
      'content' : content.toJson(),
      'size' : size,
      'number': number,
      'sort' : sort.toJson(),
      'first': first,
      'last' : last,
      'numberofElements' : numberofElements,
      'empty' : empty
    };
  }

  factory ServerMessage.fromJson(Map<String, dynamic> json){
    return ServerMessage(
      content: Content.fromJson(json['content']),
      size: json['size'],
      number: json['number'],
      sort: Standard.fromJson(json['sort']), 
      first: json['first'], 
      last: json['last'], 
      numberofElements: json['numberofElements'], 
      empty: json['empty']
    );
  }
}