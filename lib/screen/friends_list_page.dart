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

  void _skipOrComplete() {
    // Replace with actual server list logic
    List<Server> dummyServers = [
      Server(
        name: 'Server 1',
        image: File('lib/assets/default_server_image.png'),
        invitedFriends: ["Q", "B", "C"],
      ),
      Server(
        name: 'Server 2',
        image: File('lib/assets/default_server_image.png'),
        invitedFriends: ["Q", "B", "C"],
      ),
      Server(
        name: 'Server 3',
        image: File('lib/assets/default_server_image.png'),
        invitedFriends: ["Q", "B", "C"],
      ),
      Server(
        name: 'Server 4',
        image: File('lib/assets/default_server_image.png'),
        invitedFriends: ["Q", "B", "C"],
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
