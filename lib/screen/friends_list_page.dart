import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:discord_front/config/server.dart';
import 'package:discord_front/screen/server_page.dart' hide Server;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';
import '../config/palette.dart';

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
    'Friend1@naver.com',
    'Friend2@naver.com',
    'Friend3@naver.com',
    'Friend4@naver.com',
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
    var uri = Uri.parse('http://ec2-43-202-89-80.ap-northeast-2.compute.amazonaws.com:8080/server');
    final accessToken = Provider.of<AuthProvider>(context, listen: false).accessToken;
    print(accessToken);

    var request = http.MultipartRequest('POST', uri);

    if (accessToken != null) {
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      });
    }

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

    // serverInfo와 friendList를 JSON 형식의 파일로 추가
    request.files.add(http.MultipartFile.fromString(
      'serverInfo',
      json.encode({
        'name': widget.server.name,
        'description': widget.server.description,
      }),
      contentType: MediaType('application', 'json'),
    ));

    request.files.add(http.MultipartFile.fromString(
      'friendList',
      json.encode(_invitedFriends.toList()),
      contentType: MediaType('application', 'json'),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => ServerPage(
                   useremail: widget.useremail,
                 ),
               ),
             );
    } else {
      _showDialog('Error: ${response.statusCode}');
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Palette.blackColor1, // 다이얼로그 배경색 설정
          title: Text(
            'Login Error',
            style: TextStyle(color: Colors.white), // 다이얼로그 제목 텍스트 색상 설정
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white), // 다이얼로그 내용 텍스트 색상 설정
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black), // 텍스트 색상 설정
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // 버튼 배경색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0), // 모서리 둥글기 설정
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _skipOrComplete() {
  //   // Replace with actual server list logic
  //   List<Server> dummyServers = [
  //     Server(
  //       name: 'Server 1',
  //       image: File('lib/assets/default_server_image.png'),
  //       invitedFriends: ["Q", "B", "C"],
  //       description: "Server 1",
  //     ),
  //     Server(
  //       name: 'Server 2',
  //       image: File('lib/assets/default_server_image.png'),
  //       invitedFriends: ["Q", "B", "C"],
  //       description: "Server 2",
  //     ),
  //     Server(
  //       name: 'Server 3',
  //       image: File('lib/assets/default_server_image.png'),
  //       invitedFriends: ["Q", "B", "C"],
  //       description: "Server 3",
  //     ),
  //     Server(
  //       name: 'Server 4',
  //       image: File('lib/assets/default_server_image.png'),
  //       invitedFriends: ["Q", "B", "C"],
  //       description: "Server 4",
  //     ),
  //     // 추가 서버 정보를 여기에 포함시킵니다.
  //   ];
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ServerPage(
  //         serverName: widget.server.name,
  //         invitedFriends: _invitedFriends.toList(),
  //         serverImage: widget.server.image,
  //         serverList: dummyServers, // Replace with actual data
  //         useremail: widget.useremail,
  //         description: widget.server.description,
  //       ),
  //     ),
  //   );
  // }

  // 이거도 실제 주소로 바꿔야함
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
                onPressed: _sendServerData,
                child: Text(_invitedFriends.isNotEmpty ? 'Complete' : 'Skip'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
