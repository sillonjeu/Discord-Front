import 'dart:io';
import 'package:flutter/material.dart';
import 'package:discord_front/config/server.dart';
import 'package:discord_front/screen/server_page.dart';

class FriendsListPage extends StatefulWidget {
  final Server server;
  final String useremail; // 사용자 정보를 저장할 변수

  FriendsListPage({Key? key, required this.server, required this.useremail})
      : super(key: key);
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

  void _inviteFriend(String friendName) {
    setState(() {
      if (_invitedFriends.contains(friendName)) {
        _invitedFriends.remove(friendName);
      } else {
        _invitedFriends.add(friendName);
      }
    });
  }

  // 백엔드 서버로 데이터를 보내는 함수. 실제 연동 시 주석을 제거하기
  Future<void> _sendServerData() async {
    /*
    var uri = Uri.parse('http://ec2-43-202-89-80.ap-northeast-2.compute.amazonaws.com:8080/server');
    var request = http.MultipartRequest('POST', uri);

    // 서버 이미지 파일이 있으면 요청에 추가
    if (widget.server.image != null) {
      request.files.add(
        http.MultipartFile(
          'serverImage',
          widget.server.image.readAsBytes().asStream(),
          widget.server.image.lengthSync(),
          filename: widget.server.image.path.split("/").last,
        ),
      );
    }
    // 서버 정보를 JSON 형태로 변환하여 요청에 추가
    request.fields['serverInfo'] = json.encode({
      'name': widget.server.name,
      'description': widget.server.description,
    });

    // 초대된 친구 목록을 JSON 형태로 변환하여 요청에 추가
    request.fields['friendList'] = json.encode(_invitedFriends.toList());

    // 요청을 보내고 결과를 받기
    var response = await request.send();

    if (response.statusCode == 200) {
      // 성공적으로 데이터가 전송되었을 때의 처리를 여기에 작성 나중에 해야징~
    } else {
      // 오류 처리
    }
    */
  }


  void _skipOrComplete() {
    // Replace with actual server list logic
    List<Server> dummyServers = [
      Server(
        name: 'Server 1',
        image: File('lib/assets/default_server_image.png'),
        invitedFriends: ["Q", "B", "C"],
        description: "Server 1",
      ),
      Server(
        name: 'Server 2',
        image: File('lib/assets/default_server_image.png'),
        invitedFriends: ["Q", "B", "C"],
        description: "Server 2",
      ),
      Server(
        name: 'Server 3',
        image: File('lib/assets/default_server_image.png'),
        invitedFriends: ["Q", "B", "C"],
        description: "Server 3",
      ),
      Server(
        name: 'Server 4',
        image: File('lib/assets/default_server_image.png'),
        invitedFriends: ["Q", "B", "C"],
        description: "Server 4",
      ),
      // 추가 서버 정보를 여기에 포함시킵니다.
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServerPage(
          serverName: widget.server.name,
          invitedFriends: _invitedFriends.toList(),
          serverImage: widget.server.image,
          serverList: dummyServers, // Replace with actual data
          useremail: widget.useremail,
          description: widget.server.description,
        ),
      ),
    );
  }

  // Replace with dynamic link generation
  String _invitedLink = "https://invite.link/to/server";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Friends to ${widget.server.name}'),
      ),
      body: Column(
        children: [
          if (_invitedFriends.isNotEmpty)
            Container(
              color: Colors.grey[100],
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Invited Friends: ${_invitedFriends.join(', ')}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
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
