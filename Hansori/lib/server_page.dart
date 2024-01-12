// server_page.dart
import 'package:flutter/material.dart';
import 'dart:io';

class ServerPage extends StatelessWidget {
  final String serverName;
  final List<String> invitedFriends;
  final File? serverImage;

  ServerPage({
    required this.serverName,
    required this.invitedFriends,
    this.serverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serverName),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 40.0,
            backgroundImage: serverImage != null
                ? FileImage(serverImage!)
                : AssetImage('assets/default_server_image.png') as ImageProvider, // 기본 이미지
            backgroundColor: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'Invited Friends',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: invitedFriends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(invitedFriends[index]),
                );
              },
            ),
          ),
          // 버튼과 기타 UI 요소는 디자인에 따라 추가
        ],
      ),
    );
  }
}
