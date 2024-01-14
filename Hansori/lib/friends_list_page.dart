import 'dart:io';
import 'package:flutter/material.dart';
import 'server.dart'; // Server 모델을 정의한 파일을 가져옵니다.
import 'server_page.dart';

class FriendsListPage extends StatefulWidget {
  final Server server;

  FriendsListPage({
    required this.server,
  });

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final List<String> friends = [
    'Friend 1',
    'Friend 2',
    'Friend 3',
    'Friend 4',
  ];

  Set<String> _invitedFriends = {};
  List<String> _invitedFriendsDisplay = [];

  void _inviteFriend(String friendName) {
    setState(() {
      if (_invitedFriends.contains(friendName)) {
        _invitedFriends.remove(friendName);
        _invitedFriendsDisplay.remove(friendName);
      } else {
        _invitedFriends.add(friendName);
        _invitedFriendsDisplay.add(friendName);
      }
    });
  }

  void _skipOrComplete() {
    // 더미 데이터 생성
    List<Server> dummyServers = [
      Server(
        name: 'Server 1',
        invitedFriends: ['Friend A', 'Friend B'],
        image: null, // 이미지 경로 또는 파일을 지정하세요
      ),
      Server(
        name: 'Server 2',
        invitedFriends: ['Friend C', 'Friend D'],
        image: null, // 이미지 경로 또는 파일을 지정하세요
      ),
      Server(
        name: 'Server 3',
        invitedFriends: ['Friend E', 'Friend F'],
        image: null, // 이미지 경로 또는 파일을 지정하세요
      ),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServerPage(
          serverName: widget.server.name,
          invitedFriends: _invitedFriendsDisplay,
          serverImage: widget.server.image,
          serverList: dummyServers, // 더미 데이터로 채워진 서버 목록을 전달
        ),
      ),
    );
  }

  String _invitedLink = "https://invite.link/to/server";

  @override
  Widget build(BuildContext context) {
    // _image 대신 widget.serverImage를 사용하여 서버 이미지에 접근
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Friends to ${widget.server.name}'), // 서버 이름을 표시
      ),
      body: Column(
        children: [
          // 초대된 친구 목록 표시
          if (_invitedFriendsDisplay.isNotEmpty)
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Invited Friends: ${_invitedFriendsDisplay.join(', ')}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          // 링크 표시
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: SelectableText(
              'Server Link: $_invitedLink',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  title: Text(friends[index], style: TextStyle(fontSize: 16)),
                  trailing: ElevatedButton(
                    onPressed: () => _inviteFriend(friends[index]),
                    child: Text(_invitedFriends.contains(friends[index])
                        ? 'Cancel Invite'
                        : 'Invite'),
                  ),
                );
              },
            ),
          ),
          // 완료/건너뛰기 버튼을 아래 중앙에 배치
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: ElevatedButton(
                onPressed: _skipOrComplete,
                child: Text(_invitedFriends.isNotEmpty ? 'Complete' : 'Skip'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
