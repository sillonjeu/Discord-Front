import 'package:flutter/material.dart';
import 'package:hansori/server.dart';
import 'dart:io';
import 'create_server_page.dart';
import 'package:provider/provider.dart';
import 'server_list.dart'; // ServerList 모델을 가져옵니다.

class ServerPage extends StatelessWidget {
  final String serverName;
  final List<String> invitedFriends;
  final File? serverImage;
  final List<Server> serverList; // 서버 목록 추가

  ServerPage({
    required this.serverName,
    required this.invitedFriends,
    this.serverImage,
    required this.serverList, // 서버 목록 추가
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serverName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 서버 생성 페이지로 이동합니다.
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateServerPage()));
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // 왼쪽에 서버 목록 표시
          Container(
            width: 90, // 서버 목록의 폭 조절
            child: ListView(
              children: serverList.map((server) {
                return InkWell(
                  onTap: () {
                    // 클릭한 서버로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServerPage(
                          serverName: server.name,
                          invitedFriends: server.invitedFriends,
                          serverImage: server.image,
                          serverList: serverList,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: server.image != null
                              ? FileImage(server.image!)
                              : AssetImage('assets/default_server_image.png') as ImageProvider,
                          backgroundColor: Colors.grey,
                        ),
                        Text(server.name), // 서버 이름 표시
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // 나머지 화면 내용은 그대로 유지
          Expanded(
            child: Column(
              children: [
                // 서버 이미지 표시
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: serverImage != null
                            ? FileImage(serverImage!)
                            : AssetImage('assets/default_server_image.png') as ImageProvider,
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                // 초대된 친구 목록 표시
                if (invitedFriends.isNotEmpty)
                  Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Invited Friends: ${invitedFriends.join(', ')}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}